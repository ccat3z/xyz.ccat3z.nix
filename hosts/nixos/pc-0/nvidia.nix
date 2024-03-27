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

  systemd.services."nvidia-persistenced" = {
    description = "NVIDIA Persistence Daemon";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      Restart = "always";
      PIDFile = "/var/run/nvidia-persistenced/nvidia-persistenced.pid";
      ExecStart = "${lib.getExe nvidiaPackage.persistenced} --verbose";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -rf /var/run/nvidia-persistenced";
    };
  };
}
