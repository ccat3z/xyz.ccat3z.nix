{ lib, ... }:
{
  imports = [
    ./compat.nix
    ./systemd.nix
    ./profile.nix
    ../network/nebula.nix
    ../network/proxy.nix
  ];

  options =
    let
      inherit (lib) mkOption types;
    in
    {
      activateHooks = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
}
