{ pkgs, ... }:
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
