{ pkgs, ... }:
{
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.gnome.core-utilities.enable = true;

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      sarasa-gothic
      source-han-sans
      source-han-serif
      noto-fonts-color-emoji
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