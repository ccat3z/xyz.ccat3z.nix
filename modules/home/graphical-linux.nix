{ config, pkgs, lib, ... }:
{
  imports = [
    {
      config = lib.mkIf config.linuxGraphical.enable (import ./dconf.nix { inherit lib; });
    }
    ./rime
    ./argos
  ];

  options = {
    linuxGraphical.enable = lib.mkOption {
      type = lib.types.bool;
      default = pkgs.hostPlatform.isLinux;
    };
  };

  config = lib.mkIf config.linuxGraphical.enable {
    home.packages = with pkgs; [
      # Theme
      adw-gtk3
      papirus-icon-theme
      qogir-icon-theme
      (graphite-gtk-theme.overrideAttrs ({
        src = pkgs.fetchFromGitHub {
          owner = "ccat3z";
          repo = "Graphite-gtk-theme";
          rev = "bfb24e59fe84b2fdba0e8a69ff530df97346327a";
          hash = "sha256-7AoAgRLxpPBgNyhpf6YTImFsnHpXn/yeIakI0OHDoBM=";
        };
      }))

      # Font
      sarasa-gothic

      # Graphical Tools
      (firefox.override {
        nativeMessagingHosts = [ browserpass ];
      })
      gnome.gnome-tweaks
      (vscode.fhsWithPackages (pkgs: with pkgs; [ host-spawn ]))
      remmina
      dconf
      moonlight-qt
      zotero
      gnome.dconf-editor
      drawio
      virt-manager
      gedit
      d-spy
      wpsoffice-cn
      xclip
      evolution
    ] ++ (with gnomeExtensions; [
      # Gnome Extensions
      caffeine
      gsconnect
      night-theme-switcher
      user-themes
      ddterm
      just-perfection
      (gesture-improvements.overrideAttrs {
        patches = [ ./patches/gesture-improvement-45-hotfix.patch ];
        patchFlags = [ "-p4" ];
      })
      clipboard-indicator
      tiling-assistant
      wireshark
      syncthing-icon
      panel-workspace-scroll
      pkgs.astra-monitor
      pkgs.rounded-window-corners
      pkgs.translate-label
    ]);

    # Gnome terminal settings
    dconf.settings."org/gnome/terminal/legacy" = {
      headerbar = with lib.gvariant; mkMaybe type.boolean "false";
      default-show-menubar = false;
    };
  };
}

