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
    go
  ];
  my.home.sessionVariables = {
    LEDGER_FILE = "${config.my.home.homeDirectory}/Documents/ledger/main.journal";
  };
  my.programs.zsh.initExtra = ''
    if [ -f ~/.projects_profile ]; then
      . ~/.projects_profile
    fi
  '';

  my.programs.ssh.matchBlocks = {
    "macos.local" = {
      hostname = "127.0.0.1";
      user = "ccat3z";
      port = 50922;
    };
  };

  users.users.${config.myUser}.openssh.authorizedKeys.keys = [
    # libvirtd win11
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDpm8POxqbFCQo9sixWjUsYXsH3pX2ZGTqM2RI6v7AtBQA0t/7OPApQ0VvOeEmD+vSGHdnJmuqJo9iD447muuBjleXDp7Zx4dth4HjASGt0q1H5hSBk2WcpwW6qRTfr9uxvLgTgm+KCAMKaVHOPa9khrZtB+2TqkAz780M/5allvJCibIeA/W2+PQjUlCQ8gpyPlHf0P+cu0nqcEr2sqtxTAWUtsIISRUw/EAip2G5OkjgNi7iSOfH1MW8+qCV/GsWV3m2W1ArsnzP2ZHszVPI1p3pUrZlR+MZP2vKmJ562zrKHr5pfsyueQnJfxqyZS4GzKaeLRoXAOsyR9NkySaJ3HURTjzkRoLW8MyvKEw6chdt31PIFbvRp+X/CpvJcjQufJz+F7TySripfc3fJWov8eJAm4aI6S+du6oGNsNaKnGFhkoNCbDQfqpC5rYNr7QS8cnJV63SnX0gSEtj284egwIDjPsh8QftywWCG0ClPwuS1pnNEitHjdYRvCI0+ZKE= fzhan@virt11-pc-0"
    # mix-4
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj6dXkK6qPaLWZAqrDXD19tGLpWb2QNkNDVl0nILN8L6GHV9eC5e4jUVMsmMC9rlYtSUI4M9Ub6vJI5m1CkE9Weph8vaoXT2sF5nS4TybFtEnHId1seEMrA/g2uADcPLeSf0tcx+eZNR6EnxyizlzUECfH2C2/hBzrcFbPQpdUi8cjneMYw5lHDLNhwTeMQysRji4HeXJeYVTHVKhZoWFQCv+FXqXoGEg70KZET1l0EtRf96237e7Tc0ZAmvKphOH5sJes67QkQMGTK5fa7hDOzSD3ChTpY3YJgK2PSGcrNiglAN7uLKfWLnCqYpgt7QYfvUeswrLpDJZY6mAH/MzNKx3M5Nma6LvoD0YSMY4/32M5NL2TXxAbD5SndIl7n6hhIRH58zcu3jrGptImcAi2ZBRNn0WVAr3Gv4yt1PN0WLmvd5yKzy31guPl/oc6bBhVkcpHEy/YdIinXljja2lzc5zJNGq0XLKkdtqYGlloWtJAg+Gsmjpg/DKyN9Pxvz8="
  ];

  services.xserver.displayManager.gdm.autoSuspend = false;

  system.stateVersion = "23.11";
}
