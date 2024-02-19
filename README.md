# xyz.ccat3z.nix

Deployment scripts for my PC / laptop / servers ... 

## Motivation

Over the past few years, I have been attempting to backup
my self-hosted services, dotfiles and even the os.
This is to ensure that nothing is lost and
to be able to quickly recover from failures.
Prior to this repo, I used Ansible to deploy and backup the self-hosted service,
managed dotfiles on several Linux machines (including an Android phone) via Chezmoi,
and backup os with Btrfs and Btrbk.
They worked well based on several git repos and disks but became a bit complex now.
It's time to refactor and combine them with Nix (a source-based declarative package and config manager good at reproducibilty and caching)!
The current idea of this repo is outlined in the table below:

| Device | OS and System-wide Apps | Service | Home Dotfile | Project | Data (e.g. Photos, Non-coding Project) |
| -- | -- | -- | -- | -- | -- |
| laptop-0 (Daily use) | Arch Linux (btrbk) | **nixsvc** | **home manager** | btrbk | syncthing + btrbk |
| pc-0 (Build Server, NAS, Gaming) | **Headless nixos** + libvirt win11 as ui (qcow2 snapshot) | **nixos** | **home manager** | btrbk | syncthing + btrbk |
| cn-\*, us-\* (Lightwight server with public ip) | Debian (fresh install without backup) | **nixsvc** | - | - | - |
| rootless android mobile | Simple scripts based on adb | **nixsvc** + sing-box | **nix-for-android + home manager** | - | syncthing |

nixsvc is a profile similar to Home Manager, but designed for deploying configurations and services on non-NixOS systems.

## Setup nixos

``` sh
cat > ~/.config/nix/nix.conf <<EOF
experimental-features = nix-command flakes repl-flake
EOF
nix develop
cat > ~/.gnupg/gpg-agent.conf <<EOF
    pinentry-program $(which pinentry-gnome)
EOF
```

1. Setup disk
2. Generate hardware configure via nixos-generate-config. Then copy it to `./hosts/nixos/${hostname}.nix`
3. Generate agekeys to /var/lib/sops/key.txt
4. Import gpg and resign
