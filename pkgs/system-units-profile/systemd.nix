{ utils, lib, pkgs, ... }:
{
  options =
    let
      inherit (lib) mkOption types literalExpression;
    in
    {
      systemd.services = mkOption {
        default = { };
        type = utils.systemdUtils.types.services;
        description = lib.mdDoc "Definition of systemd service units.";
      };

      systemd.package = mkOption {
        default = pkgs.systemd;
        defaultText = literalExpression "pkgs.systemd";
        type = types.package;
        description = lib.mdDoc "The systemd package.";
      };

      systemd.packages = mkOption {
        default = [ ];
        type = types.listOf types.package;
        example = literalExpression "[ pkgs.systemd-cryptsetup-generator ]";
        description = lib.mdDoc "Packages providing systemd units and hooks.";
      };
    };
}
