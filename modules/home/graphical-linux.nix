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
    home = with pkgs; lib.mkMerge [
      ({
        packages = [
          # Theme
          adw-gtk3
          papirus-icon-theme
          qogir-icon-theme
          (graphite-gtk-theme.overrideAttrs ({
            src = pkgs.fetchFromGitHub {
              owner = "ccat3z";
              repo = "Graphite-gtk-theme";
              rev = "0e670f021624fce8f6267a28fea5427b64185497";
              hash = "sha256-RZfP9g4Cf6Td0D4dgcmiPQpLfDccacSYKU3xfxxGNYE=";
            };
          }))

          # Font
          sarasa-gothic

          # Graphical Tools
          (firefox.override {
            nativeMessagingHosts = [ browserpass ];
          })
          gnome.gnome-tweaks
          remmina
          dconf
          gnome.dconf-editor
          virt-manager
          gedit
          d-spy
          xclip
          evolution
        ] ++ (with gnomeExtensions; [
          # Gnome Extensions
          caffeine
          gsconnect
          pkgs.night-theme-switcher
          user-themes
          ddterm
          just-perfection
          (gesture-improvements.overrideAttrs {
            patches = [ ./patches/gesture-improvements-hotfix.patch ];
            patchFlags = [ "-p4" ];
          })
          pkgs.clipboard-indicator
          tiling-assistant
          syncthing-icon
          panel-workspace-scroll
          pkgs.astra-monitor
          pkgs.rounded-window-corners
          pkgs.translate-label
          pkgs.extend-left-box
        ]);
      })
      ({
        packages = lib.mkIf (!config.slim) [
          wireshark
          moonlight-qt
          zotero
          (vscode.fhsWithPackages (pkgs: with pkgs; [ host-spawn clang-tools_18 go ]))
          drawio
          wpsoffice-cn
        ];
      })
    ];

    # Gnome terminal settings
    dconf.settings."org/gnome/terminal/legacy" = {
      headerbar = with lib.gvariant; mkMaybe type.boolean "false";
      default-show-menubar = false;
    };
  };
}

