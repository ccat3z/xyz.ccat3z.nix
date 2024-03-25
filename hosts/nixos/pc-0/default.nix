{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ./nvidia.nix ./argos ];

  networking.useDHCP = lib.mkDefault true;
  services.proxy.enable = true;
  services.syncthing.enable = true;

  services.xserver.displayManager.gdm.autoSuspend = false;

  system.stateVersion = "23.11";
}
