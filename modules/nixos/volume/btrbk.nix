{ lib, pkgs, config, ... }:
{
  options =
    let
      inherit (lib) mkOption types;

      subvolumeType = types.submodule
        ({ config, ... }: {
          options = {
            btrbk = mkOption {
              type = types.attrsOf types.str;
              default = { };
              description = "btrbk subvolume config for volume. See btrbk.conf(5).";
            };
          };
        });
    in
    {
      subvolumes = mkOption {
        type = types.attrsOf subvolumeType;
      };
    };

  config =
    let
      btrbkConfOf = subvolCfg: {
        volume.${subvolCfg.parent}.subvolume.${subvolCfg.name} = subvolCfg.btrbk;
      };

      btrbkConf = lib.mkMerge (lib.lists.map btrbkConfOf (lib.attrValues config.subvolumes));
    in
    {
      services.btrbk.instances.default.settings = btrbkConf;
    };
}
