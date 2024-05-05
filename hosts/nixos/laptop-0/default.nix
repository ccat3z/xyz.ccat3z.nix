{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./subvolumes.nix
      ./argos
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  services.proxy.enable = true;
  services.syncthing.enable = true;

  my.home.packages = with pkgs; [
    powertop
  ];

  system.stateVersion = "23.11";
}
