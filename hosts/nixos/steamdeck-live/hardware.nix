{ config, lib, pkgs, modulesPath, ... }:

{
  hardware.enableRedistributableFirmware = true;

  boot.loader.systemd-boot.enable = true;
  boot.initrd.availableKernelModules = [
    "sdhci_pci"
    "vfat"
    "nls_cp437"
    "nls_iso8859_1"
  ];
  boot.initrd.luks.devices = lib.mapAttrs
    (n: v:
      let
        keyMountPath = "/mnt/key";
      in
      {
        device = v;
        keyFile = "${keyMountPath}/keys/${n}";
        fallbackToPassword = true;
        preOpenCommands = ''
          echo "openning ${n}..."

          mkdir -p ${keyMountPath}
          mount -t vfat ${config.fileSystems."/boot".device} ${keyMountPath}
        '';
        postOpenCommands = ''
          umount ${keyMountPath}
        '';
      })
    {
      "root0" = "/dev/disk/by-uuid/41f85366-bd4b-4354-93f3-4b814b28634d";
    };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/BAB7-5739";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/413e1aef-6ed0-42db-b657-40edb1b5d1c7";
    fsType = "btrfs";
    options = [ "subvol=rootfs" ];
  };

  fileSystems."/mnt/volume" = {
    device = "/dev/disk/by-uuid/413e1aef-6ed0-42db-b657-40edb1b5d1c7";
    fsType = "btrfs";
    options = [ "subvol=/" ];
  };

  jovian.devices.steamdeck.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
