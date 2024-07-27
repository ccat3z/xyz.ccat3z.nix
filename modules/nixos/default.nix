{ pkgs, config, ... }:
{
  imports = [
    ./users.nix
    ./graphical.nix
    ./pinned.nix
    ./network
    ./hardware
    ./crypttab.nix
    ./immich.nix
  ];

  time.timeZone = "Asia/Shanghai";

  nix.settings.experimental-features = [ "nix-command" "flakes" "repl-flake" ];
  environment.systemPackages = with pkgs; [ git vim wget ];

  # Openssh
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  # GPG
  programs.gnupg.agent.enable = true;
  programs.gnupg.agent.enableSSHSupport = true;
  nixpkgs.overlays = [
    (final: prev: {
      gnome = prev.gnome.overrideScope (gfinal: gprev: {
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

  # Syncthing
  services.syncthing = {
    user = "${config.myUser}";
    group = "${config.users.users.${config.myUser}.group}";
    extraFlags = [ "--no-default-folder" ];
  };

  # Fuse
  programs.fuse.userAllowOther = true;

  # Support unpatched dynamic binaries like vscode remote server
  programs.nix-ld.enable = true;

  # Disable configure.nix man
  documentation.nixos.enable = false;
}
