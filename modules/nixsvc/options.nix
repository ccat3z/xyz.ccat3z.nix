{ lib, ... }:
{
  options =
    {
      nixsvc.activateHooks = with lib.types; let
        inherit (lib) mkOption;
        hookType =
          let
            scriptOptions =
              {
                deps = mkOption
                  {
                    type = types.listOf types.str;
                    default = [ ];
                    description = lib.mdDoc "List of dependencies. The script will run after these.";
                  };
                text = mkOption
                  {
                    type = types.lines;
                    description = lib.mdDoc "The content of the script.";
                  };
              };
          in
          either str (submodule { options = scriptOptions; });
      in
      mkOption {
        type = attrsOf hookType;
      };
    };

  config = {
    nixsvc.activateHooks = {
      setupSecrets = lib.mkDefault "";
    };
  };
}
