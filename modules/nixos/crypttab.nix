{ lib, config, ... }:
let
  inherit (lib) mkOption types;

  fsType = types.submodule
    ({
      options.encrypted = {
        enableStage2 = lib.mkEnableOption "stage2 decrypt";
        options = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "man:crypttab(5)";
        };
      };
    });

  mkCrypttabLine = encCfg: "${encCfg.label} ${encCfg.blkDev} ${encCfg.keyFile} ${lib.concatStringsSep "," encCfg.options}";
in
{
  options = {
    fileSystems = mkOption {
      type = types.attrsOf fsType;
    };
    environment.crypttab = mkOption {
      type = types.lines;
      default = "";
    };
  };

  config = {
    assertions =
      let
        assertNotEnableBoth = name: cfg: {
          assertion = with cfg.encrypted; !(enable && enableStage2);
          message = "Cannot be decrypted ${name} in both stage 1 and stage 2";
        };
      in
      lib.mapAttrsToList assertNotEnableBoth config.fileSystems;

    environment = {
      etc."crypttab".text = config.environment.crypttab;

      crypttab = ''
        ${lib.concatStringsSep "\n"
          (lib.lists.map
            (fs: mkCrypttabLine fs.encrypted)
            (lib.filter
              (fs: fs.encrypted.enableStage2)
              (lib.attrValues config.fileSystems)
            )
          )
        }
      '';
    };
  };
}
