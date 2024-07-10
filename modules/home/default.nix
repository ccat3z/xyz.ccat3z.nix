{ config, pkgs, lib, ... }:
{
  imports = [
    ./options.nix
    ./graphical-linux.nix
  ];

  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    # Common Tools
    gnumake
    cmake
    gcc13
    neovim
    (python3.withPackages (ps: with ps; [
      pynvim
      requests
    ]))
    dconf2nix
    nix-diff
    gopass
    (unzip.override { enableNLS = true; })
    pipenv
    tree
    devenv
  ] ++ (lib.optionals pkgs.hostPlatform.isLinux [
    efibootmgr
    pciutils
    usbutils
  ]);

  services.gpg-agent = lib.mkIf pkgs.hostPlatform.isLinux {
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
  home.file.".ssh/config".target = ".ssh/config_source";
  home.activation.setupSSHConfig =
    let
      inherit (config.programs.ssh) extraConfigPath;
    in
    lib.hm.dag.entryAfter [ "onFilesChange" ] ''
      rm -f ~/.ssh/config
      touch ~/.ssh/config

      if [ -n "${extraConfigPath}" ] && [ -f "${extraConfigPath}" ]; then
        cat "${extraConfigPath}" >> ~/.ssh/config
        echo >> ~/.ssh/config
      fi

      cat ~/.ssh/config_source >> ~/.ssh/config
      chmod 400 ~/.ssh/config
    '';

  programs.git = {
    enable = true;
    extraConfig = {
      commit.gpgsign = pkgs.hostPlatform.isLinux;
      user = lib.mkDefault {
        name = "ccat3z";
        email = "fzhang.chn@outlook.com";
      };
    };
    includes = [
      {
        path = ./gitconfig.ini;
      }
    ];
  };
}
