{ pkgs, ... }:
{
  imports = [ ./proxy.nix ];

  networking.nftables.enable = true;
  networking.networkmanager.enable = true;
}
