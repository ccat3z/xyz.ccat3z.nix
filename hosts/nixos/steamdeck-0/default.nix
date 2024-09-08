{ pkgs, jovian-nixos, config, ... }: {
  imports = [
    jovian-nixos.nixosModules.default
    ./hardware.nix
    ./backport.nix
    ./nebula.nix
  ];

  services.xserver.displayManager.gdm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  jovian.steam = {
    enable = true;
    autoStart = true;
    user = config.myUser;
    desktopSession = "gnome-xorg";
  };

  environment.systemPackages = with pkgs; [
    xorg.xinit
    gnome.caribou
  ];

  # users.users.${config.myUser}.extraGroups = [ "input" ];

  my.slim = true;
  security.sudo.wheelNeedsPassword = false;

  services.proxy.enable = true;
  system.stateVersion = "24.05";
}
