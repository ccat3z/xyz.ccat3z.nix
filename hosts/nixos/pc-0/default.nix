{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ];

  boot.loader.systemd-boot.enable = true;

  networking.useDHCP = lib.mkDefault true;
  services.proxy.enable = true;

  system.stateVersion = "23.11";
}
