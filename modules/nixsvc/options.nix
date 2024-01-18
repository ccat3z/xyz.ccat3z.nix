{ lib, ... }:
{
  options =
    let
      inherit (lib) mkOption types;
    in
    {
      nixsvc.activateHooks = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
}
