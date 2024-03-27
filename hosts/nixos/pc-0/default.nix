{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ./nvidia.nix ./argos ./server.nix ./libvirtd.nix ];

  networking.useDHCP = lib.mkDefault true;
  services.proxy.enable = true;
  services.syncthing.enable = true;

  # Required by remote btrbk
  environment.systemPackages = [ pkgs.lz4 ];

  my.home.packages = [ pkgs.gocryptfs ];

  services.xserver.displayManager.gdm.autoSuspend = false;

  system.stateVersion = "23.11";
}
