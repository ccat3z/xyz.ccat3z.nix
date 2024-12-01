{ config, pkgs, lib, ... }:
let
  nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.stable;
  nvidia-modprobe = pkgs.nvidia-modprobe.override {
    version = nvidiaPackage.version;
  };
in
{
  boot.kernelModules = lib.mkBefore [ "nvidia" ]; # Make sure nvidia is load before vfio
  boot.blacklistedKernelModules = [ "nouveau" ];
  boot.extraModulePackages = [ nvidiaPackage ];
  environment.systemPackages = [ nvidiaPackage.bin ];

  services.udev.extraRules =
    ''
      ACTION=="add", DEVPATH=="/bus/pci/drivers/nvidia", \
        RUN+="${pkgs.runtimeShell} -c 'mknod -m 666 /dev/nvidiactl c 195 255'", \
        RUN+="${nvidia-modprobe}/bin/nvidia-modprobe -c 0", \
        RUN+="${nvidia-modprobe}/bin/nvidia-modprobe -c 0 -u"
    '';

  hardware.graphics = {
    extraPackages = [ nvidiaPackage.out ];
    extraPackages32 = [ nvidiaPackage.lib32 ];
  };
  environment.variables = {
    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
  };
}
