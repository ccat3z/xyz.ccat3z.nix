# Make system-units compat nixos modules

{ lib, utils, pkgs, nixpkgs, config, ... }:
{
  imports = [
    (builtins.toPath "${nixpkgs}/nixos/modules/misc/assertions.nix")
    (builtins.toPath "${nixpkgs}/nixos/modules/misc/nixpkgs.nix")
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
      # nixpkgs = mkCompatOpt { };
      environment = mkCompatOpt { };
    };

  config = {
    users.users.root.group = "root";

    _module.args =
      {
        utils = import "${nixpkgs}/nixos/lib/utils.nix" { inherit lib config pkgs; };
      };
  };
}
