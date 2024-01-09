{ pkgs, ... }:
{
  imports = [
    ./users.nix
    ./graphical.nix
    ./network
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  environment.systemPackages = with pkgs; [ git vim wget ];

  # Openssh
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";

  # GPG
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;

  # Support unpatched dynamic binaries like vscode remote server
  programs.nix-ld.enable = true;
}
