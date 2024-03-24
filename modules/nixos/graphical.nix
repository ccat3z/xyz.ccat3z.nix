{ pkgs, ... }:
{
  imports = [ ./printer.nix ];
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.gnome.core-utilities.enable = true;
  environment.gnome.excludePackages = with pkgs.gnome; [
    pkgs.gnome-console
    pkgs.loupe
    pkgs.gnome-connections
    gnome-weather
    gnome-maps
    gnome-logs
    gnome-music
    epiphany
    pkgs.gnome-tour
    gnome-contacts
  ];
  services.gnome.tracker-miners.enable = false;
  services.gnome.tracker.enable = false;

  environment.systemPackages = [
    pkgs.gnome.eog
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      sarasa-gothic
      source-han-sans
      source-han-serif
      noto-fonts-color-emoji
      source-han-sans-cn
      ttf-wps-fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Source Han Serif SC" "Noto Color Emoji" ];
        sansSerif = [ "Source Han Sans SC" "Noto Color Emoji" ];
        monospace = [ "Sarasa Mono SC" "Noto Color Emoji" ];
      };
    };
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ rime ];
  };
}
