{ pkgs, ... }: {
  imports = [
    ./options.nix
    ./pinned.nix
  ];

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.iterm2
      pkgs.firefox-bin
    ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs.config.allowUnsupportedSystem = true;

  programs.zsh.enable = true;
}
