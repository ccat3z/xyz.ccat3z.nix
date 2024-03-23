{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ./nvidia.nix ];

  networking.useDHCP = lib.mkDefault true;
  services.proxy.enable = true;

  system.stateVersion = "23.11";
}
