{ lib, ... }:
{
  imports = [
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package" ] [ "hardware" "opengl" "package" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "package32" ] [ "hardware" "opengl" "package32" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "enable32Bit" ] [ "hardware" "opengl" "driSupport32Bit" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages" ] [ "hardware" "opengl" "extraPackages" ])
    (lib.mkAliasOptionModule [ "hardware" "graphics" "extraPackages32" ] [ "hardware" "opengl" "extraPackages32" ])
  ];
}
