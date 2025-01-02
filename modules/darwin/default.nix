{ pkgs, config, lib, mac-app-util, ... }: {
  imports = [
    mac-app-util.darwinModules.default
    ./options.nix
    ./pinned.nix
  ];

  nix.settings.trusted-users = [ config.myUser ];
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.iterm2
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;
}
