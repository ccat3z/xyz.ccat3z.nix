{ lib, pkgs, ... }:
{
  options = {
    hostName = lib.mkOption {
      type = lib.types.str;
    };
  };
}
