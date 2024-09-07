{ pkgs, jovian-nixos, config, ... }: {
  imports = [
    jovian-nixos.nixosModules.default
    ./hardware.nix
    ./compat.nix
    ./unstable-pkgs.nix
    ./backport.nix
    ./nebula.nix
  ];

  services.xserver.displayManager.gdm.enable = false;
  jovian.steam = {
    enable = true;
    autoStart = true;
    user = config.myUser;
    desktopSession = "gnome-xorg";
  };

  my.slim = true;
  security.sudo.wheelNeedsPassword = false;

  services.proxy.enable = true;
  system.stateVersion = "24.05";
}
