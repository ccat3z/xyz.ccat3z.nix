{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.loader.systemd-boot.enable = true;
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
    "usb_storage"
    "uas"
    "sd_mod"
    # Required by luks key part
    "vfat"
    "nls_cp437"
    "nls_iso8859_1"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

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
      "root0" = "/dev/disk/by-uuid/056076b1-1099-4a42-b150-cf125ff2426e";
      "root1" = "/dev/disk/by-uuid/5ebb7404-2c04-4eb0-afde-552d0afb7c49";
    };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/562eab94-9110-469b-9ff6-21ac246a4748";
    fsType = "btrfs";
    options = [ "subvol=nix/rootfs" ];
  };

  fileSystems."/mnt/volume" = {
    device = "/dev/disk/by-uuid/562eab94-9110-469b-9ff6-21ac246a4748";
    fsType = "btrfs";
  };

  fileSystems."/home/${config.home.user}/Documents" = {
    device = "/dev/disk/by-uuid/562eab94-9110-469b-9ff6-21ac246a4748";
    fsType = "btrfs";
    options = [ "subvol=project" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7CB2-1143";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
