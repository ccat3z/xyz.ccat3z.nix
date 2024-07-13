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
    gocryptfs
    hledger
    hledger-web
    git-remote-gcrypt
  ];

  my.home.sessionVariables = {
    LEDGER_FILE = "${config.my.home.homeDirectory}/Documents/ledger/main.journal";
  };

  my.programs.zsh.initExtra = ''
    if [ -f ~/.projects_profile ]; then
      . ~/.projects_profile
    fi
  '';

  my.programs.ssh = {
    matchBlocks = {
      "win11.local" = {
        hostname = "192.168.122.11";
        user = "fzhan";
      };
    };
    extraConfigPath = config.sops.secrets."laptop-0_ssh_config".path;
  };

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
