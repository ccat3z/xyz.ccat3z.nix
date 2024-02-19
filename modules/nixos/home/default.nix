{ config, pkgs, ... }:
{
  imports = [
    ./dconf.nix
  ];

  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    # Theme
    adw-gtk3
    papirus-icon-theme
    qogir-icon-theme
    (graphite-gtk-theme.overrideAttrs ({
      src = pkgs.fetchFromGitHub {
        owner = "ccat3z";
        repo = "Graphite-gtk-theme";
        rev = "d2c94965d22de519e3d677b6bb4e90e9ae31d9c5";
        hash = "sha256-Y0TLg+HqXTLZsMsazlReVo8GgvN8dl4YHSdE69qeE7c=";
      };
    }))

    # Font
    sarasa-gothic

    # Common Tools
    gnumake
    cmake
    gcc13
    neovim
    (python3.withPackages (ps: with ps; [
      pynvim
    ]))
    dconf2nix

    # Graphical Tools
    firefox
    gnome.gnome-tweaks
    (gnome.gnome-terminal.overrideAttrs {
      patches = [./patches/gnome-terminal-resize.patch];
    })
    vscode.fhs
    remmina
    dconf
    moonlight-qt
    zotero
    gnome.dconf-editor
    drawio
    virt-manager
  ] ++ (with gnomeExtensions; [
    # Gnome Extensions
    caffeine
    gsconnect
    night-theme-switcher
    user-themes
    ddterm
    just-perfection
    (gesture-improvements.overrideAttrs {
      patches = [./patches/gesture-improvement-45-hotfix.patch];
      patchFlags = ["-p4"];
    })
    clipboard-indicator
    tiling-assistant
    wireshark
    syncthing-icon
  ]);

  services.gpg-agent = {
    enable = true;
    sshKeys = [
      "820B065395559FC5024BE32BB27AC53E147B969B"
    ];
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "fishy";
    };
  };

  programs.vim =
    let
      inherit (pkgs.vimPlugins) vim-plug;
    in
    {
      enable = true;
      defaultEditor = true;
      plugins = [ vim-plug ];
      extraConfig = ''
        source ${vim-plug}/plug.vim
        
        ${builtins.readFile ./init.vim}
      '';
    };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "pc-0.ccat3z.xyz" = {
        hostname = "10.55.12.2";
        user = "ccat3z";
      };
    };
  };
  # Fix ssh config permission
  # https://github.com/nix-community/home-manager/issues/322#issuecomment-1856128020
  home.file.".ssh/config" = {
    target = ".ssh/config_source";
    onChange = ''cat ~/.ssh/config_source > ~/.ssh/config && chmod 400 ~/.ssh/config'';
  };

  programs.git = {
    enable = true;
    includes = [
      {
        path = ./gitconfig.ini;
      }
    ];
  };

  services.syncthing = {
    enable = true;
    extraOptions = [
      "--home=/mnt/syncthing/config"
      "--no-default-folder"
    ];
  };
}
