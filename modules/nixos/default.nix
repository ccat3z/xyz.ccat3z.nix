{ pkgs, ... }:
{
  imports = [
    ./users.nix
    ./graphical.nix
    ./pinned.nix
    ../network
    ../nixsvc/options.nix
  ];

  time.timeZone = "Asia/Shanghai";

  nix.settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  environment.systemPackages = with pkgs; [ git vim wget ];
  nixpkgs.config.allowUnfree = true;

  # Openssh
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # GPG
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope' (gfinal: gprev: {
        gnome-keyring = gprev.gnome-keyring.overrideAttrs (oldAttrs: {
          configureFlags = oldAttrs.configureFlags or [ ] ++ [
            "--disable-ssh-agent"
          ];
        });
      });
    })
  ];

  # Docker
  virtualisation.docker.enable = true;

  # Support unpatched dynamic binaries like vscode remote server
  programs.nix-ld.enable = true;
}
