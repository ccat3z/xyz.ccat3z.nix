# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

with lib.hm.gvariant;

{
  dconf.settings = {
    "com/github/amezin/ddterm" = {
      background-color = "rgb(33,33,33)";
      background-opacity = 0.95;
      bold-color = "#c5c8c6";
      bold-color-same-as-fg = true;
      bold-is-bright = true;
      cursor-background-color = "#c5c8c6";
      cursor-colors-set = true;
      cursor-foreground-color = "#1d1f21";
      ddterm-toggle-hotkey = [ "<Control><Alt>d" ];
      foreground-color = "#c5c8c6";
      hide-animation = "ease-in-expo";
      hide-when-focus-lost = false;
      hide-window-on-esc = false;
      highlight-background-color = "#000000";
      highlight-colors-set = true;
      highlight-foreground-color = "#ffffff";
      new-tab-button = false;
      new-tab-front-button = false;
      override-window-animation = true;
      palette = [ "#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#c5c8c6" "#969896" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#ffffff" ];
      panel-icon-type = "none";
      pointer-autohide = false;
      scroll-on-output = false;
      scrollback-lines = 10001;
      show-animation = "ease-in-expo";
      show-banner = false;
      show-scrollbar = false;
      tab-close-buttons = false;
      tab-expand = true;
      tab-label-ellipsize-mode = "middle";
      tab-label-width = 0.1;
      tab-policy = "automatic";
      tab-position = "bottom";
      tab-switcher-popup = false;
      theme-variant = "system";
      transparent-background = true;
      use-gnome-terminal-colors = true;
      use-theme-colors = false;
      window-above = true;
      window-height = 0.430887;
      window-maximize = false;
      window-monitor = "current";
      window-position = "left";
      window-resizable = false;
      window-size = 0.467708;
      window-skip-taskbar = true;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      cursor-theme = "Qogir-dark";
      enable-animations = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close:appmenu";
    };

    "org/gnome/shell" = {
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" "caffeine@patapon.info" "nightthemeswitcher@romainvigier.fr" "gsconnect@andyholmes.github.io" "just-perfection-desktop@just-perfection" "ddterm@amezin.github.com" "clipboard-indicator@tudmotu.com" ];
      favorite-apps = [ "org.gnome.Nautilus.desktop" "firefox.desktop" ];
    };

    "org/gnome/shell/extensions/caffeine" = {
      indicator-position-max = -1;
      toggle-state = true;
      user-enabled = true;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      clear-history = [];
      next-entry = [];
      prev-entry = [];
      private-mode-binding = [];
      toggle-menu = [ "<Super>c" ];
    };

    "org/gnome/shell/extensions/just-perfection" = {
      activities-button = false;
      clock-menu-position = 2;
      clock-menu-position-offset = 0;
      notification-banner-position = 0;
      window-demands-attention-focus = true;
      workspace = true;
    };

    "org/gnome/shell/extensions/nightthemeswitcher/cursor-variants" = {
      enabled = false;
    };

    "org/gnome/shell/extensions/nightthemeswitcher/gtk-variants" = {
      day = "adw-gtk3";
      enabled = true;
      night = "adw-gtk3-dark";
    };

    "org/gnome/shell/extensions/nightthemeswitcher/icon-variants" = {
      day = "Papirus-Light";
      enabled = true;
      night = "Papirus-Dark";
    };

    "org/gnome/shell/extensions/nightthemeswitcher/shell-variants" = {
      day = "Graphite";
      enabled = true;
      night = "Graphite-Dark";
    };

    "org/gnome/shell/extensions/nightthemeswitcher/time" = {
      manual-schedule = false;
      nightthemeswitcher-ondemand-keybinding = [ "<Shift><Super>t" ];
    };

    "org/gnome/system/location" = {
      enabled = true;
    };

    "org/gnome/terminal/legacy" = {
      default-show-menubar = false;
      headerbar = false;
      menu-accelerator-enabled = true;
      mnemonics-enabled = false;
      new-terminal-mode = "tab";
      schema-version = mkUint32 3;
      theme-variant = "system";
    };

    "org/gnome/terminal/legacy/profiles:" = {
      default = "a44eab9f-9645-4c49-9bac-73528357ef44";
      list = [ "3ea7e0a6-5da1-47cb-9c43-80cfd2c70acf" "a44eab9f-9645-4c49-9bac-73528357ef44" ];
    };

    "org/gnome/terminal/legacy/profiles:/:3ea7e0a6-5da1-47cb-9c43-80cfd2c70acf" = {
      audible-bell = false;
      background-color = "rgb(45,45,45)";
      bold-color = "#d3d0c8";
      bold-color-same-as-fg = true;
      bold-is-bright = true;
      cjk-utf8-ambiguous-width = "narrow";
      cursor-background-color = "#d3d0c8";
      cursor-colors-set = true;
      cursor-foreground-color = "#2d2d2d";
      cursor-shape = "underline";
      custom-command = "fish";
      default-size-columns = 100;
      font = "Sarasa Term SC 14";
      foreground-color = "rgb(211,208,200)";
      highlight-colors-set = true;
      login-shell = false;
      palette = [ "#2d2d2d" "#f2777a" "#99cc99" "#ffcc66" "#6699cc" "#cc99cc" "#66cccc" "#d3d0c8" "#747369" "#f2777a" "#99cc99" "#ffcc66" "#6699cc" "#cc99cc" "#66cccc" "#f2f0ec" ];
      scroll-on-keystroke = true;
      scroll-on-output = false;
      scrollbar-policy = "never";
      use-custom-command = false;
      use-system-font = false;
      use-theme-background = false;
      use-theme-colors = false;
      visible-name = "Base 16 Eighties 256";
    };

    "org/gnome/terminal/legacy/profiles:/:a44eab9f-9645-4c49-9bac-73528357ef44" = {
      audible-bell = true;
      background-color = "rgb(33,33,33)";
      bold-color = "#c5c8c6";
      bold-color-same-as-fg = true;
      bold-is-bright = true;
      cjk-utf8-ambiguous-width = "narrow";
      cursor-background-color = "#c5c8c6";
      cursor-colors-set = true;
      cursor-foreground-color = "#1d1f21";
      cursor-shape = "underline";
      custom-command = "fish";
      default-size-columns = 100;
      font = "Sarasa Term SC 14";
      foreground-color = "#c5c8c6";
      highlight-colors-set = true;
      login-shell = false;
      palette = [ "#1d1f21" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#c5c8c6" "#969896" "#cc6666" "#b5bd68" "#f0c674" "#81a2be" "#b294bb" "#8abeb7" "#ffffff" ];
      scroll-on-keystroke = true;
      scroll-on-output = false;
      scrollbar-policy = "never";
      use-custom-command = false;
      use-system-font = false;
      use-theme-background = false;
      use-theme-colors = false;
      visible-name = "Base 16 Tomorrow Night 256";
    };

    "org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9" = {
      background-color = "rgb(46,52,54)";
      background-transparency-percent = 8;
      bold-is-bright = true;
      cursor-shape = "underline";
      default-size-columns = 100;
      font = "Inziu Iosevka SC 14";
      foreground-color = "rgb(211,215,207)";
      palette = [ "rgb(46,52,54)" "rgb(204,0,0)" "rgb(78,154,6)" "rgb(196,160,0)" "rgb(52,101,164)" "rgb(117,80,123)" "rgb(6,152,154)" "rgb(211,215,207)" "rgb(85,87,83)" "rgb(239,41,41)" "rgb(138,226,52)" "rgb(252,233,79)" "rgb(114,159,207)" "rgb(173,127,168)" "rgb(52,226,226)" "rgb(238,238,236)" ];
      scroll-on-output = false;
      scrollbar-policy = "never";
      use-system-font = false;
      use-theme-colors = false;
      use-transparent-background = true;
      visible-name = "c0ldcat";
    };

  };
}
