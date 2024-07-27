{ config, lib, pkgs, home-manager, ... }:

{
  imports =
    [
      ./hardware.nix
      ./subvolumes.nix
      ./libvirt.nix
      ./nebula.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  services.proxy.enable = true;
  services.syncthing.enable = true;

  services.xserver.displayManager.gdm.autoSuspend = false;
  my.dconf.settings = {
    "org/gnome/desktop/notifications".show-in-lock-screen = false;
    "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
  };

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

  sops.secrets.ssh_config = {
    sopsFile = ./ssh_config.enc;
    format = "binary";
    mode = "0444";
  };
  my.programs.ssh = {
    matchBlocks = {
      "win11.local" = {
        hostname = "192.168.122.11";
        user = "fzhan";
      };
    };
    extraConfigPath = config.sops.secrets.ssh_config.path;
  };
  my.home.activation.triggerSSHExtraConfig = home-manager.lib.hm.dag.entryBefore [ "setupSSHConfig" ] ''
    # Ref ${config.sops.secrets.ssh_config.sopsFile}
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
