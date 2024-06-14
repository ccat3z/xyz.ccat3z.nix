{ lib, ... }:
{
  options.myUser = lib.mkOption {
    type = lib.types.str;
  };
}
