{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware.nix ./nvidia.nix ./argos ./server.nix ./libvirtd.nix ./nebula.nix ];

  networking.useDHCP = lib.mkDefault true;
  services.proxy.enable = true;
  services.syncthing.enable = true;

  # Required by remote btrbk
  environment.systemPackages = [ pkgs.lz4 ];

  my.home.packages = with pkgs; [
    gocryptfs
    hledger
    hledger-web
    git-remote-gcrypt
    bc
    android-tools
    iopaint
    a1111-webui-env
    android-studio
  ];
  my.home.sessionVariables = {
    LEDGER_FILE = "${config.my.home.homeDirectory}/Documents/ledger/main.journal";
  };
  my.programs.zsh.initExtra = ''
    if [ -f ~/.projects_profile ]; then
      . ~/.projects_profile
    fi
  '';

  users.users.${config.myUser}.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpm8POxqbFCQo9sixWjUsYXsH3pX2ZGTqM2RI6v7AtBQA0t/7OPApQ0VvOeEmD+vSGHdnJmuqJo9iD447muuBjleXDp7Zx4dth4HjASGt0q1H5hSBk2WcpwW6qRTfr9uxvLgTgm+KCAMKaVHOPa9khrZtB+2TqkAz780M/5allvJCibIeA/W2+PQjUlCQ8gpyPlHf0P+cu0nqcEr2sqtxTAWUtsIISRUw/EAip2G5OkjgNi7iSOfH1MW8+qCV/GsWV3m2W1ArsnzP2ZHszVPI1p3pUrZlR+MZP2vKmJ562zrKHr5pfsyueQnJfxqyZS4GzKaeLRoXAOsyR9NkySaJ3HURTjzkRoLW8MyvKEw6chdt31PIFbvRp+X/CpvJcjQufJz+F7TySripfc3fJWov8eJAm4aI6S+du6oGNsNaKnGFhkoNCbDQfqpC5rYNr7QS8cnJV63SnX0gSEtj284egwIDjPsh8QftywWCG0ClPwuS1pnNEitHjdYRvCI0+ZKE= fzhan@virt11-pc-0"
  ];

  services.xserver.displayManager.gdm.autoSuspend = false;

  system.stateVersion = "23.11";
}
