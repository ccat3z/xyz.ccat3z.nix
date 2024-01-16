{ config, pkgs, ... }:
let
  sshAuthorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC78zZLsyWn/h6q043x0hKK3VsK0As0YzJH61LX+wU11tttucWU0ES5i6O2qU4EpZAAfHR5H/vNvPVbupmG/MSi6eCJ/DOhpwoC4STt7y96P3Pw5daNijUNPcxrOLP1sp9CvAg9VEtvl74kIJEdn1HGUStyid4xOGafsJnE8C+SS+gshEW2zkhghg5Xoxm+s2PpPVjrUUWYBCUDZWa1Zb7pN9S/lPnHN72NcXOE12+o+fHHEPgBPovWEE0407jg8pOLH7JxuQIRQLxCmHEsN9Ikt9KG5WTtq70SDMoGnRCZJBj8qrF6ZFeUoFFDLj/olQqDKA9mpI1m9NPGHaCcGvRn openpgp:0xC98E1B0F"
  ];
in
{
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets."users/password".path;
      openssh.authorizedKeys = sshAuthorizedKeys;
    };
    ccat3z = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" ];
      packages = with pkgs; [
        chezmoi
        oh-my-zsh
        gcc13
        neovim
        (vim-full.customize (with vimPlugins; {
          vimrcConfig.packages.myVimPackage = {
            start = [ vim-plug ];
            opt = [ ];
          };

          vimrcConfig.customRC = ''
            source ${vim-plug}/plug.vim
            source ~/.vimrc
          '';
        }))
        (python3.withPackages (ps: with ps; [
          pynvim
        ]))
        cmake

        # graphical
        firefox
        gnome.gnome-tweaks
        papirus-icon-theme
        gnomeExtensions.user-themes
        gnomeExtensions.ddterm

        vscode.fhs
        remmina
        gnome.gnome-terminal
        dconf
        moonlight-qt
      ];
      hashedPasswordFile = config.sops.secrets."users/password".path;
      openssh.authorizedKeys = sshAuthorizedKeys;
      shell = pkgs.zsh;
    };
  };
}
