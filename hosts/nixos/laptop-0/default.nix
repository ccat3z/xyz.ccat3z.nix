{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./subvolumes.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  services.proxy.enable = true;

  system.stateVersion = "23.11";

}
