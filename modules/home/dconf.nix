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
      use-system-font = true;
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

    "org/gnome/desktop/input-sources" = {
      mru-sources = [ (mkTuple [ "ibus" "rime" ]) (mkTuple [ "xkb" "us" ]) ];
      sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "ibus" "rime" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };

    "org/gnome/desktop/interface" = {
      cursor-theme = "Qogir-dark";
      document-font-name = "Serif 11";
      enable-animations = true;
      font-antialiasing = "grayscale";
      font-hinting = "slight";
      font-name = "Sans 11";
      monospace-font-name = "Monospace 14";
      show-battery-percentage = true;
      toolkit-accessibility = false;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      speed = 0.0;
      tap-to-click = true;
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      always-on-top = [ "<Super>T" ];
      maximize = [ ];
      move-to-workspace-1 = [ "<Shift><Super>exclam" ];
      move-to-workspace-2 = [ "<Shift><Super>at" ];
      move-to-workspace-3 = [ "<Shift><Super>numbersign" ];
      move-to-workspace-4 = [ "<Shift><Super>4" ];
      move-to-workspace-5 = [ "<Shift><Super>5" ];
      move-to-workspace-6 = [ "<Shift><Super>6" ];
      move-to-workspace-7 = [ "<Shift><Super>7" ];
      move-to-workspace-8 = [ "<Shift><Super>8" ];
      move-to-workspace-9 = [ "<Shift><Super>9" ];
      move-to-workspace-down = [ "<Shift><Super>Page_Down" ];
      move-to-workspace-last = [ "<Shift><Super>End" ];
      move-to-workspace-left = [ "<Primary><Shift><Super>Left" ];
      move-to-workspace-right = [ "<Primary><Shift><Super>Right" ];
      move-to-workspace-up = [ "<Shift><Super>Page_Up" ];
      switch-applications = [ ];
      switch-applications-backward = [ ];
      switch-to-workspace-1 = [ "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-down = [ "<Super>Page_Down" ];
      switch-to-workspace-left = [ "<Primary><Super>Left" ];
      switch-to-workspace-right = [ "<Primary><Super>Right" ];
      switch-to-workspace-up = [ "<Super>Page_Up" ];
      switch-windows = [ "<Alt>Tab" ];
      switch-windows-backward = [ "<Shift><Alt>Tab" ];
      toggle-fullscreen = [ ];
      toggle-maximized = [ "<Super>m" ];
      toggle-on-all-workspaces = [ "<Super>s" ];
      unmaximize = [ ];
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close:appmenu";
      titlebar-font = "Sans 11";
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = false;
      workspaces-only-on-primary = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Control><Alt>t";
      command = "gnome-terminal";
      name = "Terminal";
    };

    "org/gnome/shell" = {
      enabled-extensions = [ "user-theme@gnome-shell-extensions.gcampax.github.com" "caffeine@patapon.info" "nightthemeswitcher@romainvigier.fr" "gsconnect@andyholmes.github.io" "just-perfection-desktop@just-perfection" "ddterm@amezin.github.com" "clipboard-indicator@tudmotu.com" "tiling-assistant@leleat-on-github" "gestureImprovements@gestures" "monitor@astraext.github.io" "panel-workspace-scroll@polymeilex.github.io" "syncthingicon@jay.strict@posteo.de" "rounded-window-corners@fxgn" "argos@pew.worldwidemann.com" "translate-label@ccat3z.xyz" "extend-left-box@ccat3z.xyz" ];
      favorite-apps = [ "org.gnome.Nautilus.desktop" "firefox.desktop" ];
    };

    "org/gnome/shell/extensions/astra-monitor" = {
      gpu-indicators-order = "[\"icon\",\"activity bar\",\"activity graph\",\"activity percentage\",\"memory bar\",\"memory graph\",\"memory percentage\",\"memory value\"]";
      headers-height = 0;
      headers-height-override = 0;
      memory-header-bars = false;
      memory-header-bars-breakdown = true;
      memory-header-graph = true;
      memory-header-graph-breakdown = true;
      memory-header-icon = false;
      memory-header-percentage = false;
      memory-header-tooltip = false;
      memory-indicators-order = "[\"icon\",\"bar\",\"graph\",\"percentage\",\"value\",\"free\"]";
      memory-menu-graph-breakdown = true;
      monitors-order = "[\"processor\",\"memory\",\"network\",\"storage\",\"sensors\",\"gpu\"]";
      network-header-icon = false;
      network-header-tooltip = false;
      network-indicators-order = "[\"icon\",\"IO bar\",\"IO graph\",\"IO speed\"]";
      panel-box-order = -2;
      processor-header-bars = false;
      processor-header-bars-breakdown = true;
      processor-header-bars-core = false;
      processor-header-icon = false;
      processor-header-percentage = false;
      processor-header-percentage-core = false;
      processor-header-tooltip = false;
      processor-indicators-order = "[\"icon\",\"bar\",\"graph\",\"percentage\",\"frequency\"]";
      processor-menu-gpu-color = "";
      processor-menu-top-processes-percentage-core = true;
      profiles = ''
        {"default":{"panel-margin-left":0,"sensors-header-tooltip-sensor2-digits":-1,"memory-update":3,"gpu-header-memory-graph-color1":"rgba(29,172,214,1.0)","panel-box":"right","memory-header-show":true,"network-header-tooltip-io":true,"processor-header-bars-color2":"rgba(214,29,29,1.0)","processor-header-icon-size":18,"storage-source-storage-io":"auto","sensors-header-tooltip-sensor4-name":"","storage-header-icon-color":"","network-source-public-ipv4":"https://api.ipify.org","storage-header-io-graph-color2":"rgba(214,29,29,1.0)","storage-header-io":false,"processor-menu-top-processes-percentage-core":true,"sensors-header-sensor1":"\\"\\"","processor-header-graph":true,"storage-header-graph-width":30,"network-header-bars":false,"processor-source-load-avg":"auto","network-menu-arrow-color1":"rgba(29,172,214,1.0)","network-source-top-processes":"auto","gpu-header-icon":true,"processor-menu-graph-breakdown":true,"sensors-header-icon-custom":"","sensors-header-sensor2":"\\"\\"","network-header-icon-alert-color":"rgba(235, 64, 52, 1)","memory-header-tooltip-free":false,"storage-header-io-figures":2,"network-menu-arrow-color2":"rgba(214,29,29,1.0)","sensors-header-tooltip-sensor3-name":"","network-source-public-ipv6":"https://api6.ipify.org","monitors-order":"[\\"processor\\",\\"memory\\",\\"network\\",\\"storage\\",\\"sensors\\"]","network-header-graph":true,"network-indicators-order":"[\\"icon\\",\\"IO bar\\",\\"IO graph\\",\\"IO speed\\"]","memory-header-percentage":false,"processor-header-tooltip":false,"gpu-main":"\\"\\"","storage-header-bars":true,"sensors-header-tooltip-sensor5-digits":-1,"memory-menu-swap-color":"rgba(29,172,214,1.0)","storage-io-unit":"kB/s","processor-header-graph-color1":"rgba(29,172,214,1.0)","memory-header-graph-width":30,"storage-header-tooltip-value":false,"gpu-header-icon-custom":"","processor-header-graph-breakdown":true,"panel-margin-right":0,"processor-header-frequency":false,"processor-source-cpu-usage":"auto","sensors-header-tooltip-sensor3-digits":-1,"gpu-header-icon-size":18,"memory-header-value-figures":3,"compact-mode":false,"processor-header-frequency-mode":"average","panel-box-order":-2,"compact-mode-compact-icon-custom":"","network-header-graph-width":30,"gpu-header-tooltip":true,"sensors-header-icon":true,"gpu-header-activity-percentage-icon-alert-threshold":0,"sensors-header-sensor2-digits":-1,"processor-header-graph-color2":"rgba(214,29,29,1.0)","sensors-header-icon-alert-color":"rgba(235, 64, 52, 1)","sensors-update":3,"gpu-header-tooltip-memory-value":true,"processor-header-bars":false,"gpu-header-tooltip-memory-percentage":true,"gpu-header-memory-bar-color1":"rgba(29,172,214,1.0)","sensors-header-tooltip-sensor1":"\\"\\"","sensors-header-tooltip-sensor1-digits":-1,"storage-header-free-figures":3,"processor-header-percentage-core":false,"sensors-header-tooltip-sensor2-name":"","network-source-network-io":"auto","memory-header-bars":false,"processor-header-percentage":false,"processor-header-frequency-figures":3,"storage-header-io-threshold":0,"memory-header-graph-color1":"rgba(29,172,214,1.0)","compact-mode-activation":"both","storage-header-icon-size":18,"sensors-header-tooltip-sensor1-name":"","sensors-header-icon-size":18,"sensors-header-icon-color":"","explicit-zero":false,"sensors-source":"auto","storage-header-io-graph-color1":"rgba(29,172,214,1.0)","storage-header-percentage-icon-alert-threshold":0,"sensors-header-tooltip-sensor2":"\\"\\"","compact-mode-expanded-icon-custom":"","memory-header-graph-color2":"rgba(29,172,214,0.3)","processor-header-icon-alert-color":"rgba(235, 64, 52, 1)","processor-header-tooltip-percentage":true,"gpu-header-show":false,"network-update":1.5,"sensors-header-tooltip-sensor3":"\\"\\"","sensors-ignored-attribute-regex":"","memory-header-icon-custom":"","storage-header-tooltip-io":true,"sensors-header-tooltip-sensor4":"\\"\\"","storage-header-percentage":false,"sensors-temperature-unit":"celsius","storage-header-icon-alert-color":"rgba(235, 64, 52, 1)","storage-header-free-icon-alert-threshold":0,"memory-source-top-processes":"auto","storage-header-value-figures":3,"storage-header-io-bars-color1":"rgba(29,172,214,1.0)","storage-menu-arrow-color1":"rgba(29,172,214,1.0)","gpu-header-tooltip-activity-percentage":true,"network-header-icon-custom":"","processor-header-graph-width":30,"network-header-icon":false,"storage-menu-arrow-color2":"rgba(214,29,29,1.0)","sensors-header-sensor2-layout":"vertical","sensors-header-tooltip-sensor5":"\\"\\"","memory-header-bars-breakdown":true,"sensors-header-show":false,"sensors-header-tooltip":false,"storage-header-tooltip":false,"processor-header-bars-core":false,"storage-indicators-order":"[\\"icon\\",\\"bar\\",\\"percentage\\",\\"value\\",\\"free\\",\\"IO bar\\",\\"IO graph\\",\\"IO speed\\"]","processor-menu-bars-breakdown":true,"storage-header-io-bars-color2":"rgba(214,29,29,1.0)","network-io-unit":"kB/s","storage-header-icon":false,"gpu-header-activity-graph-color1":"rgba(29,172,214,1.0)","memory-unit":"kB-KB","processor-menu-core-bars-breakdown":true,"sensors-header-sensor2-show":false,"network-header-tooltip":false,"storage-header-tooltip-free":true,"storage-header-bars-color1":"rgba(29,172,214,1.0)","theme-style":"dark","storage-source-storage-usage":"auto","network-header-io":false,"storage-main":"name-root0","memory-header-tooltip-percentage":true,"memory-indicators-order":"[\\"icon\\",\\"bar\\",\\"graph\\",\\"percentage\\",\\"value\\",\\"free\\"]","memory-source-memory-usage":"auto","memory-header-graph-breakdown":true,"memory-header-tooltip-value":true,"memory-menu-graph-breakdown":true,"sensors-indicators-order":"[\\"icon\\",\\"value\\"]","compact-mode-start-expanded":false,"startup-delay":2,"memory-header-percentage-icon-alert-threshold":0,"sensors-header-sensor1-show":false,"network-ignored-regex":"","storage-update":3,"memory-header-value":false,"memory-header-bars-color1":"rgba(29,172,214,1.0)","network-header-io-graph-color1":"rgba(29,172,214,1.0)","gpu-header-memory-bar":true,"memory-used":"total-free-buffers-cached","gpu-header-memory-graph-width":30,"gpu-header-memory-graph":false,"sensors-ignored-category-regex":"","headers-font-family":"","memory-header-icon":false,"network-header-io-graph-color2":"rgba(214,29,29,1.0)","memory-header-bars-color2":"rgba(29,172,214,0.3)","processor-gpu":true,"network-header-icon-color":"","storage-header-value":false,"gpu-header-icon-alert-color":"rgba(235, 64, 52, 1)","processor-header-icon":false,"headers-font-size":0,"network-header-io-figures":2,"network-header-show":true,"sensors-ignored-regex":"","network-header-io-bars-color1":"rgba(29,172,214,1.0)","processor-update":1.5,"network-source-wireless":"auto","processor-indicators-order":"[\\"icon\\",\\"bar\\",\\"graph\\",\\"percentage\\"]","storage-header-icon-custom":"","gpu-header-activity-bar":true,"gpu-header-activity-bar-color1":"rgba(29,172,214,1.0)","shell-bar-position":"top","network-ignored":"\\"[]\\"","network-header-io-bars-color2":"rgba(214,29,29,1.0)","memory-header-icon-color":"","sensors-header-sensor1-digits":-1,"storage-header-io-layout":"vertical","memory-header-icon-size":18,"network-header-io-threshold":0,"storage-header-show":false,"sensors-header-tooltip-sensor4-digits":-1,"processor-header-percentage-icon-alert-threshold":0,"memory-header-tooltip":false,"headers-height-override":0,"memory-header-graph":true,"network-header-icon-size":18,"gpu-header-icon-color":"","memory-header-free-figures":3,"storage-header-io-bars":false,"processor-header-bars-breakdown":true,"gpu-header-activity-graph":false,"storage-ignored":"\\"[]\\"","memory-header-icon-alert-color":"rgba(235, 64, 52, 1)","storage-header-free":false,"processor-header-icon-custom":"","gpu-header-memory-percentage":false,"processor-header-tooltip-percentage-core":false,"processor-source-cpu-cores-usage":"auto","processor-source-top-processes":"auto","processor-header-icon-color":"","sensors-header-tooltip-sensor5-name":"","gpu-header-activity-graph-width":30,"gpu-header-activity-percentage":false,"gpu-indicators-order":"\\"\\"","network-header-io-layout":"vertical","gpu-update":1.5,"gpu-header-memory-percentage-icon-alert-threshold":0,"processor-header-bars-color1":"rgba(29,172,214,1.0)","processor-header-show":true,"storage-header-graph":false,"memory-header-free-icon-alert-threshold":0,"storage-ignored-regex":"","storage-menu-device-color":"rgba(29,172,214,1.0)","storage-header-tooltip-percentage":true,"memory-header-free":false,"storage-source-top-processes":"auto"}}
      '';
      queued-pref-category = "";
      sensors-indicators-order = "[\"icon\",\"value\"]";
      storage-header-bars = true;
      storage-header-icon = false;
      storage-header-percentage = false;
      storage-header-show = false;
      storage-header-tooltip = false;
      storage-header-tooltip-percentage = true;
      storage-indicators-order = "[\"icon\",\"bar\",\"percentage\",\"value\",\"free\",\"IO bar\",\"IO graph\",\"IO speed\"]";
      storage-main = "name-root3";
      theme-style = "dark";
    };

    "org/gnome/shell/extensions/caffeine" = {
      restore-state = true;
    };

    "org/gnome/shell/extensions/clipboard-indicator" = {
      clear-history = [ ];
      display-mode = 0;
      move-item-first = false;
      next-entry = [ ];
      paste-button = false;
      prev-entry = [ ];
      preview-size = 50;
      private-mode-binding = [ ];
      strip-text = true;
      toggle-menu = [ "<Super>c" ];
    };

    "org/gnome/shell/extensions/gestureImprovements" = {
      allow-minimize-window = false;
      default-overview-gesture-direction = true;
      default-session-workspace = false;
      enable-forward-back-gesture = false;
      enable-window-manipulation-gesture = false;
      overview-navifation-states = "CYCLIC";
      pinch-4-finger-gesture = "NONE";
      touchpad-speed-scale = 1.0;
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

    "org/gnome/shell/extensions/tiling-assistant" = {
      activate-layout0 = [ ];
      activate-layout1 = [ ];
      activate-layout2 = [ ];
      activate-layout3 = [ ];
      active-window-hint = 1;
      active-window-hint-color = "rgb(51,51,51)";
      auto-tile = [ "<Super>f" ];
      center-window = [ ];
      change-favorite-layout = [ ];
      changelog-version = 33;
      current-tiling-mode = "right";
      debugging-free-rects = [ ];
      debugging-show-tiled-rects = [ ];
      default-move-mode = 0;
      dynamic-keybinding-behavior = 0;
      dynamic-keybinding-behaviour = 0;
      enable-advanced-experimental-features = true;
      enable-dynamic-tiling = true;
      enable-pie-menu = false;
      enable-raise-tile-group = true;
      enable-tiling-mode = false;
      enable-tiling-popup = false;
      favorite-layout = 0;
      favorite-layouts = [ "-1" "-1" ];
      focus-hint-color = "rgb(53,132,228)";
      import-layout-examples = false;
      last-version-installed = 47;
      layouts-overview = [ ];
      maximize-with-gap = false;
      move-favorite-layout-mod = "Alt";
      restore-window = [ "<Super>Down" ];
      restore-window-size-on = "Grab End";
      screen-bottom-gap = 0;
      screen-gap = 4;
      screen-left-gap = 0;
      screen-right-gap = 0;
      screen-top-gap = 0;
      search-popup-layout = [ ];
      show-layout-panel-indicator = false;
      tile-bottom-half = [ ];
      tile-bottom-half-ignore-ta = [ ];
      tile-bottomleft-quarter = [ ];
      tile-bottomleft-quarter-ignore-ta = [ ];
      tile-bottomright-quarter = [ ];
      tile-bottomright-quarter-ignore-ta = [ ];
      tile-edit-mode = [ "<Super>e" ];
      tile-left-half = [ "<Super>Left" ];
      tile-left-half-ignore-ta = [ ];
      tile-maximize = [ "<Super>Up" ];
      tile-maximize-horizontally = [ ];
      tile-maximize-vertically = [ ];
      tile-right-half = [ "<Super>Right" ];
      tile-right-half-ignore-ta = [ ];
      tile-top-half = [ ];
      tile-top-half-ignore-ta = [ ];
      tile-topleft-quarter = [ ];
      tile-topleft-quarter-ignore-ta = [ ];
      tile-topright-quarter = [ ];
      tile-topright-quarter-ignore-ta = [ ];
      tiling-popup-all-workspace = false;
      toggle-always-on-top = [ ];
      toggle-tiling-popup = [ ];
      window-gap = 5;
    };

    "org/gnome/shell/keybindings" = {
      focus-active-notification = [ ];
      switch-to-application-1 = [ ];
      switch-to-application-2 = [ ];
      switch-to-application-3 = [ ];
      switch-to-application-4 = [ ];
      switch-to-application-5 = [ ];
      switch-to-application-6 = [ ];
      switch-to-application-7 = [ ];
      switch-to-application-8 = [ ];
      switch-to-application-9 = [ ];
      toggle-application-view = [ "<Super>a" ];
      toggle-message-tray = [ "<Super>n" ];
      toggle-overview = [ "" ];
    };

    "org/gnome/system/location" = {
      enabled = true;
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
