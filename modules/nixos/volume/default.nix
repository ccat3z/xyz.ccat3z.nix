{ lib, config, ... }:
{
  imports = [ ./btrbk.nix ./luks.nix ];
  options =
    let
      inherit (lib) mkOption types mkIf;
      inherit (builtins) hasAttr;
      subvolumeType = types.submodule ({ name, config, ... }@args: {
        options = {
          parent = mkOption {
            type = types.path;
            description = "Parent dir of volume";
          };
          name = mkOption {
            type = types.str;
            description = "Name of volume";
            default = name;
          };
          path = mkOption {
            type = types.path;
            description = "Path to volume";
            default = config.parent + "/" + config.name;
            readOnly = true;
          };
        };
      });
    in
    {
      subvolumes = mkOption {
        type = types.attrsOf subvolumeType;
        default = { };
        description = "Define of stateful volumes";
      };
    };
}
