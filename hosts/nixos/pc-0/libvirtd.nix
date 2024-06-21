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

    environment.systemPackages = [
      (pkgs.writeScriptBin "libvirt-win11-inputs" ''
        #! /usr/bin/env sh

        set -e

        if [ "$UID" != 0 ]; then
            echo "Root is required." >&2
            exit 1
        fi

        domain=win11

        # attach_usb vendor product
        attach_usb () {
            virsh attach-device "$domain" --file <(
                cat <<EOF
        <hostdev mode="subsystem" type="usb">
          <source>
            <vendor id="0x$1"/>
            <product id="0x$2"/>
          </source>
        </hostdev>
        EOF
        )
        }

        # detach_usb vendor product
        detach_usb () {
            virsh detach-device "$domain" --file <(
                cat <<EOF
        <hostdev mode="subsystem" type="usb">
          <source>
            <vendor id="0x$1"/>
            <product id="0x$2"/>
          </source>
        </hostdev>
        EOF
        )
        }

        case "$1" in
            attach)
                attach_usb 413c 301c # Mouse
                attach_usb 1a81 1202 # Keyboard
                ;;
            detach)
                detach_usb 413c 301c # Mouse
                detach_usb 1a81 1202 # Keyboard
                ;;
            *)
                echo "usage: $0 attach|detach" >&2
                ;;
        esac
      '')
    ];
  }
  (lib.mkIf (lib.length pciIds > 0)
    {
      # See also https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF

      boot.kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      boot.kernelModules = [ "vfio" "vfio_iommu_type1" "vfio_pci" /* "vfio_virqfd" */ ];
      boot.extraModprobeConfig = "options vfio-pci ids=${lib.concatStringsSep "," pciIds}";
    })
]
