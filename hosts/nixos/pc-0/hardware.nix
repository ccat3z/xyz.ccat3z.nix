{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/562eab94-9110-469b-9ff6-21ac246a4748";
    fsType = "btrfs";
    options = [ "subvol=nix/rootfs" ];
  };

  boot.initrd.luks.devices = {
    "root0".device = "/dev/disk/by-uuid/056076b1-1099-4a42-b150-cf125ff2426e";
    "root1".device = "/dev/disk/by-uuid/5ebb7404-2c04-4eb0-afde-552d0afb7c49";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7CB2-1143";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
