{ lib, pkgs, ... }:
{
  nixpkgs.overlays = lib.mkAfter [
    (final: super:
      let
        inherit (pkgs) fetchFromGitHub fetchpatch kernelPatches callPackage;
      in
      {
        linux_jovian = callPackage ./linux-jovian {
          kernelPatches = [
            kernelPatches.bridge_stp_helper
            kernelPatches.request_key_helper
            kernelPatches.export-rt-sched-migrate
          ];
        };
      })
  ];
}
