{ config, lib, pkgs, ... }:
{
  options.topLevel =
    let
      inherit (lib) mkOption types;
    in
    mkOption {
      type = types.package;
    };

  config.topLevel =
    let
      inherit (pkgs) writeTextFile;
      inherit (lib) mkOption types mapAttrs;

      # Handle assertions and warnings
      failedAssertions = with lib; map (x: x.message) (filter (x: !x.assertion) config.assertions);
      assertWarnOr = x:
        with lib;
        if failedAssertions != [ ]
        then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
        else showWarnings config.warnings x;

      activateHooks = mapAttrs (name: hook: if builtins.isString hook then (lib.noDepEntry hook) else hook) config.nixsvc.activateHooks;
    in
    assertWarnOr (
      (writeTextFile {
        name = "nixsvc-profile";
        text = with lib; ''
          #! /usr/bin/env bash

          ${textClosureMap id activateHooks (builtins.attrNames activateHooks)}
        '';
        executable = true;
        destination = "/activate";
      }).overrideAttrs {
        passthru = {
          inherit config;
        };
      }
    );
}
