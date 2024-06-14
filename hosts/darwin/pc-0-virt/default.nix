{ pkgs, ... }: {
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  system.keyboard.enableKeyMapping = true;
  system.keyboard.swapLeftCommandAndLeftAlt = true;

  myUser = "ccat3z";

  environment.systemPackages = [
    pkgs.vscode
  ];
}
