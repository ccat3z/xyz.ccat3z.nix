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
  services.syncthing.enable = true;

  my.home.packages = with pkgs; [
    powertop
  ];

  my.programs.zsh.initExtra = ''
    if [ -f ~/.projects_profile ]; then
      . ~/.projects_profile
    fi
  '';

  system.stateVersion = "23.11";
}
