{ pkgs, lib, config, ... }:
{
  imports = [
    ./printer.nix
  ];

  options = {
    gui.enable = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.hostPlatform.isLinux;
    };
  };

  config = lib.mkIf config.gui.enable {
    services.xserver.enable = true;
    services.xserver.desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
      extraGSettingsOverrides = ''
        [org.gnome.mutter]
        experimental-features=['scale-monitor-framebuffer']
      '';
    };
    services.xserver.displayManager.gdm.enable = lib.mkDefault true;
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

    environment.systemPackages = with pkgs; [
      gnome.eog
      gnome.nautilus-python
      (gnome.gnome-terminal.overrideAttrs {
        patches = [ ./patches/gnome-terminal-resize.patch ];
      })
    ];

    # FIXME: All non-python nautilus extensions must be placed in systemPackages to work.
    # This will only take effect after re-login.
    environment.sessionVariables = {
      NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";
    };

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

    hardware.pulseaudio.enable = false;
    services.pipewire = {
      audio.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
