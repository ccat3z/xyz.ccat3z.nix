{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption types mkIf;
in
{
  options.hardware.fan2go = {
    enable = lib.mkEnableOption (lib.mdDoc "fan2go");

    config = mkOption {
      type = types.str;
      description = "Configure for fan2go.";
    };

    hwmonModules = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };
  };

  config =
    let
      cfg = config.hardware.fan2go;
    in
    mkIf cfg.enable {
      environment.etc = {
        "fan2go/fan2go.yaml".text = cfg.config;
        "lm_sensors".text = ''
          HWMON_MODULES="${lib.concatStringsSep " " cfg.hwmonModules}"
        '';
      };

      systemd.services.lm_sensors = {
        description = "Initialize hardware monitoring sensors";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          EnvironmentFile = "/etc/lm_sensors";
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = [
            "-${pkgs.kmod}/bin/modprobe -qab $BUS_MODULES $HWMON_MODULES"
            "${pkgs.lm_sensors}/bin/sensors -s"
          ];
          ExecStop = [
            "-${pkgs.kmod}/bin/modprobe -qabr $BUS_MODULES $HWMON_MODULES"
          ];
        };
      };

      systemd.services.fan2go = {
        description = "Advanced Fan Control program";
        after = [ "lm_sensors.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          LimitNOFILE = 8192;
          ExecStart = "${pkgs.fan2go}/bin/fan2go -c /etc/fan2go/fan2go.yaml --no-style";
          Restart = "always";
          RestartSec = "1s";
        };
      };
    };
}

