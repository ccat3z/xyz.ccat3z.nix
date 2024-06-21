{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
      ./subvolumes.nix
      ./libvirt.nix
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

  services.udev.extraRules = ''
    # UDISKS_FILESYSTEM_SHARED
    # ==1: mount filesystem to a shared directory (/media/VolumeName)
    # ==0: mount filesystem to a private directory (/run/media/$USER/VolumeName)
    # See udisks(8)
    ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{UDISKS_FILESYSTEM_SHARED}="1"
  '';
  systemd.tmpfiles.rules = [
    "d /media 0755 :root :root"
  ];

  system.stateVersion = "23.11";
}
