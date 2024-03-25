{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./subvolumes.nix
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

  fileSystems."/mnt/backup" = {
    device = "/dev/disk/by-uuid/27228342-55d9-4497-bcbe-437e48393746";
    fsType = "btrfs";
    options = [ "ssd" "nofail" ];
    encrypted = {
      enableStage2 = true;
      blkDev = "/dev/disk/by-uuid/aad38218-8ecd-4a69-8843-b50af8ce553e";
      label = "backup";
      keyFile = "/etc/cryptsetup-keys.d/backup-981.key";
      options = [ "discard" "nofail" ];
    };
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/7CB2-1143";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.logitech-k380.enable = true;

  hardware.fan2go = {
    enable = true;
    hwmonModules = [ "coretemp" "nct6775" ];
    config = ''
      maxRpmDiffForSettledFan: 20
      fans:
        - id: case
          hwmon:
            platform: nct6798-isa-0a20
            rpmChannel: 6
            pwmChannel: 6
          minPwm: 80
          maxPwm: 145
          neverStop: true
          curve: cpu_curve
      sensors:
        - id: cpu_package
          hwmon:
            platform: coretemp
            index: 1
      curves:
        - id: cpu_curve
          linear:
            sensor: cpu_package
            min: 40
            max: 70
    '';
  };
}
