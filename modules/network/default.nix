{ pkgs, ... }:
{
  networking.nftables.enable = true;
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [ ];
}
