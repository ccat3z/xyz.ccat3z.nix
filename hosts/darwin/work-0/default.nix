{ pkgs, ... }: {
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.keyboard.enableKeyMapping = true;

  myUser = "ccat3z";

  homebrew = {
    enable = true;
    casks = [
      "wechat"
    ];
  };

  my.programs.zsh.initExtra = ''
    eval "$(/opt/homebrew/bin/brew shellenv)"
  '';

  environment.systemPackages = [
    pkgs.vscode
  ];
}
