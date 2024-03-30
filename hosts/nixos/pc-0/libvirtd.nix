{ lib, pkgs, ... }:
let
  pciIds = [
    # NVIDIA GPU
    "10de:1f03"
    "10de:10f9"
    # Toshiba NVME SSD
    "1179:0116"
  ];
in
lib.mkMerge [
  {
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    # Required for windows 11 vm
    boot.extraModprobeConfig = "options kvm ignore_msrs=1 report_ignored_msrs=0";

    # See https://www.reddit.com/r/VFIO/comments/zi70zn/usb_passthrough_a_xbox_controller/
    boot.blacklistedKernelModules = [ "xpad" ];

    environment.variables.LIBVIRT_DEFAULT_URI = "qemu:///system";
  }
  (lib.mkIf (lib.length pciIds > 0)
    {
      # See also https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF

      boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" /* "vfio_virqfd" */ ];
      boot.extraModprobeConfig = "options vfio-pci ids=${lib.concatStringsSep "," pciIds}";
    })
]
