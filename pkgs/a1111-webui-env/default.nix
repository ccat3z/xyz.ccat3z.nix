# Depends on https://github.com/virchau13/automatic1111-webui-nix
{ pkgs, ... }:
let
  # Nvidia cuda deps
  cudaPackages = pkgs.cudaPackages_12_1;
  hardwareDeps = [
    cudaPackages.cudatoolkit
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

  export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (deps ++ hardwareDeps)}:/run/opengl-driver/lib"

  exec "$@"
''
