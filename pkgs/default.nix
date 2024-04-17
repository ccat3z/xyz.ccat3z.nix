{ nixpkgs, dream2nix, ... }:
let
  lib = nixpkgs.lib;

  callPackage = lib.callPackageWith (nixpkgs // mypkgs // {
    super = nixpkgs;
    misc = import ../misc {
      inherit dream2nix nixpkgs;
    };
  });

  mypkgsNames = with lib.attrsets; attrNames (
    filterAttrs
      (n: v: v == "directory")
      (builtins.readDir ./.)
  );

  mypkgs = with builtins; listToAttrs (map
    (n: {
      name = n;
      value = callPackage ./${n} { };
    })
    mypkgsNames
  );
in
mypkgs
