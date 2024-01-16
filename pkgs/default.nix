{ nixpkgs, ... }:
let
  lib = nixpkgs.lib;
  pkgsNames = with lib.attrsets; attrNames (
    filterAttrs
      (n: v: v == "directory")
      (builtins.readDir ./.)
  );
  callPackage = lib.callPackageWith (nixpkgs // pkgs // { super = nixpkgs; });
  pkgs = with builtins; listToAttrs (map
    (n: {
      name = n;
      value = callPackage ./${n} { };
    })
    pkgsNames
  );
in
pkgs
