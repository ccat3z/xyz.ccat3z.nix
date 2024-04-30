Deployment scripts for my PC / laptop / servers ... 

## Setup new nixos on remote host

1. Boot nixos livecd on remote host
1. Prepare hardware configure
   1. Prepare filesystem and generate hardware configure via `nixos-generate-config --root /mnt`
   2. Copy nix files from `/mnt/etc/nixos` to `hosts/nixos/${host}` in this repo.
1. Prepare age key
   1. `age-keygen` and copy age key to `/var/lib/sops/key.txt` on remote host.
   2. Update `.sops.yaml` and update secrets via `./secrets/updatekeys.sh`
1. Build nixos on local host: `nix build .#nixosConfigurations.${host}.config.system.build.toplevel`
1. Copy result to remote: `nix copy --to "ssh://root@${host}?remote-store=/mnt" ./result`
1. Set system profile: `nix-env --store /mnt -p /mnt/nix/var/nix/profiles/system --set $(readlink ./result)`
1. Setup bootloader: `NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root "/mnt" -c "/run/current-system/bin/switch-to-configuration boot"`
   1. Please ensure that decryption is work in nixos-enter before reboot


## TODO

* [ ] Split v2ray config for different hosts