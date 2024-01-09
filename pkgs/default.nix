{ pkgs, ... }:
let
  lib = pkgs.lib;
  pkgsNames = with lib.attrsets; attrNames (
    filterAttrs
      (n: v: v == "directory")
      (builtins.readDir ./.)
  );
in
with builtins; listToAttrs (
  builtins.map
    (n: {
      name = n;
      value = pkgs.callPackage ./${n} { };
    })
    pkgsNames
)
