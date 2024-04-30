{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/mapper/root0";
      fsType = "btrfs";
      options = [ "subvol=nixos/rootfs" ];
    };

  boot.initrd.luks.devices."root0".device = "/dev/disk/by-uuid/bbd9ff34-d2fd-44b6-9ab8-ba9209d2a487";
  boot.initrd.luks.devices."root1".device = "/dev/disk/by-uuid/6945e98f-61ee-40a6-a89a-1d0bacb38fe5";
  boot.initrd.luks.devices."root2".device = "/dev/disk/by-uuid/572efb56-b2dc-4181-bd67-80a9e1af0eea";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/BCD4-32EC";
      fsType = "vfat";
    };


  swapDevices = [ ];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
