# Make system-units compat nixos modules

{ lib, utils, modulesPath, pkgs, config, ... }:
{
  imports = [
    (builtins.toPath "${modulesPath}/misc/assertions.nix")
  ];

  options =
    let
      inherit (lib) mkOption types;
      mkCompatOpt = default: mkOption { type = types.anything; inherit default; };
    in
    {
      users = mkCompatOpt { };
      networking = mkCompatOpt { };
      system = mkCompatOpt { };
      boot = mkCompatOpt { };
      fileSystems = mkCompatOpt { };
      swapDevices = mkCompatOpt { };
      nixpkgs = mkCompatOpt { };
      environment = mkCompatOpt { };
      hardware = mkCompatOpt { };
    };

  config = {
    users.users.root.group = "root";

    _module.args = {
      utils = import "${modulesPath}/../lib/utils.nix" { inherit lib config pkgs; };
    };
  };
}
