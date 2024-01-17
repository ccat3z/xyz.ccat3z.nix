{ lib, pkgs, runCommandLocal, v2ray, ... }:
evalModulesArg:
let
  config = (lib.evalModules (
    let
      baseArg = evalModulesArg;
    in
    baseArg // {
      modules = [
        ./nixos.nix
        ./systemd.nix
      ] ++ baseArg.modules;
      specialArgs = {
        inherit pkgs;
      } // baseArg.specialArgs;
    }
  )).config;

  # Handle assertions and warnings
  failedAssertions = with lib; map (x: x.message) (filter (x: !x.assertion) config.assertions);
  assertWarnOr = x:
    with lib;
    if failedAssertions != [ ]
    then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else showWarnings config.warnings x;
in
assertWarnOr (
  runCommandLocal "system-units-profile"
  {
    passthru = {
      inherit config;
    };
  } ''
    mkdir -p "$out/etc/systemd"

    cp ${./activate} $out/activate
    chmod +x $out/activate
    ln -s "${config.systemd.systemUnits}" "$out/etc/systemd/system"
  ''
)
