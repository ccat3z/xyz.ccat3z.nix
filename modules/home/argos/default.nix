{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption types;

  mkArgosScripts = scripts: pkgs.runCommand "argos-scripts"
    { }
    ''
      mkdir -p "$out"
      ${lib.concatStringsSep "\n"
        (lib.mapAttrsToList (n: v: "ln -s ${v} $out/${n}") scripts)}
    '';

  icons = with builtins; map (v: ./icons/${v}) (attrNames (readDir ./icons));
in
{
  options = {
    programs.argos.scripts = mkOption {
      type = types.attrsOf types.path;
      default = { };
    };

    programs.argos.scriptsPackage = mkOption {
      type = types.package;
      default = mkArgosScripts config.programs.argos.scripts;
      readOnly = true;
    };
  };

  imports = [
    ./optional.nix
  ];

  config = lib.mkIf config.linuxGraphical.enable {
    home.packages = [
      (pkgs.gnomeExtensions.argos.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "p-e-w";
          repo = "argos";
          rev = "cd0de7c79072979bed41e0ad75741bbd8e113950";
          hash = "sha256-rNS2rvHZOpl9mSoERfsX6UfEaAb6lWTI9y6HXKrl81E=";
        };
        version = "latest";
        patches = [ ./argos.patch ];
      })
    ];

    home.file = {
      ".config/argos".source = config.programs.argos.scriptsPackage;
    } // (lib.listToAttrs (lib.lists.map
      (v: {
        name = ".local/share/icons/hicolor/symbolic/apps/${builtins.baseNameOf v}";
        value = { source = v; };
      })
      icons));

    programs.argos.scripts = lib.listToAttrs (
      lib.lists.map
        (v: {
          name = builtins.baseNameOf v;
          value = v;
        })
        [
          ./ip.+.sh
          ./gfw.30s.sh
        ]
    );
  };
}
