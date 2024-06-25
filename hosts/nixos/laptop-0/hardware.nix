{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" "uas" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/mapper/root3";
      fsType = "btrfs";
      options = [ "subvol=nixos/rootfs" ];
    };

  fileSystems."/mnt/volume" =
    {
      device = "/dev/mapper/root3";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."root3".device = "/dev/disk/by-uuid/cc4d260d-8701-4f25-90a9-dfceabb487eb";

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/A444-E8B5";
      fsType = "vfat";
    };

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/555a3aaa-9cdb-4601-93ba-4127c24dfa61";
    fsType = "btrfs";
    options = [ "ssd" "nofail" ];
    encrypted = {
      enableStage2 = true;
      blkDev = "/dev/disk/by-uuid/c8bbc2f7-16b7-4101-ab91-d6893b6d0f1a";
      label = "backup";
      keyFile = "/etc/cryptsetup-keys.d/backup";
      options = [ "discard" "nofail" ];
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/79ba2a9a-0321-4dec-a192-845292e2db49";
    }
  ];

  networking.useDHCP = lib.mkDefault true;

  systemd.tmpfiles.rules = [
    # Disable nvidia gpu
    "w /sys/bus/pci/devices/0000:01:00.0/remove - - - - 1"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
