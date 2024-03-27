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
      ACTION=="add", KERNEL=="nvidia", DRIVER=="nvidia", RUN+="${nvidia-modprobe}/bin/nvidia-modprobe", \
      RUN+="${nvidia-modprobe}/bin/nvidia-modprobe -c 0 -u"
    '';
}
