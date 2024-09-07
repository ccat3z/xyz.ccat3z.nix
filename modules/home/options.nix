{ lib, pkgs, ... }:
{
  options = {
    hostName = lib.mkOption {
      type = lib.types.str;
    };

    programs.ssh.extraConfigPath = lib.mkOption {
      type = lib.types.str;
      default = "";
    };

    slim = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };
}
