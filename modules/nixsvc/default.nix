{ lib, ... }:
{
  imports = [
    ./options.nix
    ./compat.nix
    ./systemd.nix
    ./profile.nix
    ../network/nebula.nix
    ../network/proxy.nix
  ];
}
