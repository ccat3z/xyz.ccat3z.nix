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
        keyDevice = "/dev/disk/by-uuid/623D-415A";
        keyMountPath = "/mnt/key";
      in
      {
        device = v;
        keyFile = "${keyMountPath}/keys/${n}";
        fallbackToPassword = true;
        preOpenCommands = ''
          echo "openning ${n}..."

          mkdir -p ${keyMountPath}
          mount -t vfat ${keyDevice} ${keyMountPath}
        '';
        postOpenCommands = ''
          umount ${keyMountPath}
        '';
      })
    {
      "root0" = "/dev/disk/by-uuid/c28bb98a-159b-4779-9f70-4d8987e3efa6";
    };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/623D-415A";
    fsType = "vfat";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/164416e5-e216-4765-9abb-3b5003552320";
    fsType = "btrfs";
    options = [ "subvol=rootfs" ];
  };

  fileSystems."/mnt/volume" = {
    device = "/dev/disk/by-uuid/164416e5-e216-4765-9abb-3b5003552320";
    fsType = "btrfs";
    options = [ "subvol=/" ];
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/28367a56-ed70-4139-82ee-9213e6ded4f0";
    }
  ];

  jovian.devices.steamdeck.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
