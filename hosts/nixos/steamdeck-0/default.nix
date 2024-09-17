{ pkgs, jovian-nixos, config, ... }: {
  imports = [
    jovian-nixos.nixosModules.default
    ./hardware.nix
    ./nebula.nix
  ];

  services.xserver.displayManager.gdm.enable = false;
  jovian.steam = {
    enable = true;
    autoStart = true;
    user = config.myUser;
    desktopSession = "gnome";
  };

  environment.systemPackages = with pkgs; [
    (writeScriptBin "with-tcmalloc" ''
      #! /bin/sh

      exec env LD_PRELOAD=${gperftools}/lib/libtcmalloc_minimal.so:${pkgsi686Linux.gperftools}/lib/libtcmalloc_minimal.so "$@"
    '')
    tproxy-helper
  ];

  my.home.packages = with pkgs; [
    sc-controller
  ];

  boot.tmp.cleanOnBoot = true;

  services.logind.killUserProcesses = true;

  programs.steam.extest.enable = true;

  my.slim = true;

  services.proxy.enable = true;
  system.stateVersion = "24.05";
}

