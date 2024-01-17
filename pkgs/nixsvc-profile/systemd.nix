{ utils, lib, pkgs, config, ... }:
let
  inherit (utils) systemdUtils;
in
{
  options =
    let
      inherit (lib) mkOption types literalExpression;
    in
    {
      systemd.units = mkOption {
        description = lib.mdDoc "Definition of systemd units.";
        default = { };
        type = systemdUtils.types.units;
      };

      systemd.services = mkOption {
        default = { };
        type = with types; attrsOf (submodule [
          systemdUtils.unitOptions.stage2ServiceOptions
          systemdUtils.lib.unitConfig
          systemdUtils.lib.serviceConfig
        ]);
        description = lib.mdDoc "Definition of systemd service units.";
      };

      systemd.package = mkOption {
        default = pkgs.systemd;
        defaultText = literalExpression "pkgs.systemd";
        type = types.package;
        description = lib.mdDoc "The systemd package.";
      };

      systemd.packages = mkOption {
        default = [ ];
        type = types.listOf types.package;
        example = literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
        description = lib.mdDoc "Packages providing systemd units and hooks.";
      };

      systemd.globalEnvironment = mkOption {
        type = with types; attrsOf (nullOr (oneOf [ str path package ]));
        default = { };
        example = { TZ = "CET"; };
        description = lib.mdDoc ''
          Environment variables passed to *all* systemd units.
        '';
      };

      systemd.systemUnits = mkOption {
        type = types.package;
      };
    };

  config = {
    systemd.units =
      let
        inherit (lib) mapAttrs' nameValuePair;
        inherit (systemdUtils.lib) serviceToUnit;
      in
      mapAttrs' (n: v: nameValuePair "${n}.service" (serviceToUnit n v)) config.systemd.services;

    systemd.systemUnits =
      with lib;
      let
        typeDir = "system";
        cfg = config.systemd;
        packages = cfg.packages;
        units = cfg.units;
        lndir = "${pkgs.buildPackages.xorg.lndir}/bin/lndir";
      in
      pkgs.runCommand "system-units"
        {
          preferLocalBuild = true;
          allowSubstitutes = false;
        } ''
        mkdir -p $out

        # Symlink all units provided listed in systemd.packages.
        packages="${toString packages}"

        # Filter duplicate directories
        declare -A unique_packages
        for k in $packages ; do unique_packages[$k]=1 ; done

        for i in ''${!unique_packages[@]}; do
          for fn in $i/etc/systemd/${typeDir}/* $i/lib/systemd/${typeDir}/*; do
            if ! [[ "$fn" =~ .wants$ ]]; then
              if [[ -d "$fn" ]]; then
                targetDir="$out/$(basename "$fn")"
                mkdir -p "$targetDir"
                ${lndir} "$fn" "$targetDir"
              else
                ln -s $fn $out/
              fi
            fi
          done
        done

        # Symlink units defined by systemd.units where override strategy
        # shall be automatically detected. If these are also provided by
        # systemd or systemd.packages, then add them as
        # <unit-name>.d/overrides.conf, which makes them extend the
        # upstream unit.
        for i in ${toString (mapAttrsToList
            (n: v: v.unit)
            (lib.filterAttrs (n: v: (attrByPath [ "overrideStrategy" ] "asDropinIfExists" v) == "asDropinIfExists") units))}; do
          fn=$(basename $i/*)
          if [ -e $out/$fn ]; then
            if [ "$(readlink -f $i/$fn)" = /dev/null ]; then
              ln -sfn /dev/null $out/$fn
            else
              mkdir -p $out/$fn.d
              ln -s $i/$fn $out/$fn.d/overrides.conf
            fi
         else
            ln -fs $i/$fn $out/
          fi
        done

        # Symlink units defined by systemd.units which shall be
        # treated as drop-in file.
        for i in ${toString (mapAttrsToList
            (n: v: v.unit)
            (lib.filterAttrs (n: v: v ? overrideStrategy && v.overrideStrategy == "asDropin") units))}; do
          fn=$(basename $i/*)
          mkdir -p $out/$fn.d
          ln -s $i/$fn $out/$fn.d/overrides.conf
        done

        # Create service aliases from aliases option.
        ${concatStrings (mapAttrsToList (name: unit:
            concatMapStrings (name2: ''
              ln -sfn '${name}' $out/'${name2}'
            '') (unit.aliases or [])) units)}

        # Create .wants and .requires symlinks from the wantedBy and
        # requiredBy options.
        ${concatStrings (mapAttrsToList (name: unit:
            concatMapStrings (name2: ''
              mkdir -p $out/'${name2}.wants'
              ln -sfn '../${name}' $out/'${name2}.wants'/
            '') (unit.wantedBy or [])) units)}

        ${concatStrings (mapAttrsToList (name: unit:
            concatMapStrings (name2: ''
              mkdir -p $out/'${name2}.requires'
              ln -sfn '../${name}' $out/'${name2}.requires'/
            '') (unit.requiredBy or [])) units)}
      ''; # */
  };
}
