{ config, pkgs, lib, ... }:
let
  nvidiaPackage = config.boot.kernelPackages.nvidiaPackages.stable;
  nvidia-modprobe = pkgs.nvidia-modprobe.override {
    version = nvidiaPackage.version;
  };

  # Depends on https://github.com/virchau13/automatic1111-webui-nix
  a1111-webui-env =
    let
      # Nvidia cuda deps
      cudaPackages = pkgs.cudaPackages_12_1;
      hardwareDeps = [
        cudaPackages.cudatoolkit
        nvidiaPackage
      ] ++ (with pkgs; [
        xorg.libXi
        xorg.libXmu
        freeglut
        xorg.libXext
        xorg.libX11
        xorg.libXv
        xorg.libXrandr
        zlib

        # for xformers
        gcc
      ]);

      deps = with pkgs; [
        git # The program instantly crashes if git is not present, even if everything is already downloaded
        python310
        stdenv.cc.cc.lib
        stdenv.cc
        ncurses5
        binutils
        gitRepo
        gnupg
        autoconf
        curl
        procps
        gnumake
        util-linux
        m4
        gperf
        unzip
        libGLU
        libGL
        glib
      ];
    in
    pkgs.writeScriptBin "a1111-webui-env" ''
      #! ${pkgs.runtimeShell}

      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (deps ++ hardwareDeps)}"
      export CUDA_PATH="${cudaPackages.cudatoolkit}"
      export EXTRA_LDFLAGS="-L${nvidiaPackage}/lib"

      exec "$@"
    '';
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

  my.home.packages = [ a1111-webui-env ];
}
