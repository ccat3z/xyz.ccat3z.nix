{ pkgs, ... }:
{
  imports = [ ./proxy.nix ./nebula.nix ];

  networking.nftables.enable = true;
  networking.networkmanager.enable = true;
}
