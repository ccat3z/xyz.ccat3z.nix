{ pkgs, lib, config, ... }:
let
  inherit (pkgs) v2ray;
in
{
  options.services = {
    proxy = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
      };
      tproxy = lib.mkOption {
        type = lib.types.bool;
        default = true;
      };
      configSops = lib.mkOption {
        type = lib.types.str;
        default = "v2ray.yaml";
      };
    };
  };

  config =
    let
      cfg = config.services.proxy;
    in
    lib.mkIf cfg.enable
      {
        environment.systemPackages = [ v2ray ];

        systemd.packages = with pkgs; [ v2ray ];
        systemd.services.v2ray =
          {
            wantedBy = [ "multi-user.target" ];
            preStart = lib.mkIf cfg.tproxy "${lib.getExe pkgs.tproxy-helper} up";
            preStop = lib.mkIf cfg.tproxy "${lib.getExe pkgs.tproxy-helper} down";
            serviceConfig = {
              # https://github.com/NixOS/nixpkgs/issues/63703#issuecomment-504836857
              ExecStart = [
                ""
                "${lib.getBin v2ray}/bin/v2ray run -config ${config.sops.secrets.${cfg.configSops}.path}"
              ];
            };
          };

        # Fix tproxy in docker
        # FIXME
        networking.firewall.enable = false;
        boot.kernelModules = [ "br_netfilter" ];
        boot.kernel.sysctl = {
          "net.bridge.bridge-nf-call-arptables" = 0;
          "net.bridge.bridge-nf-call-ip6tables" = 0;
          "net.bridge.bridge-nf-call-iptables" = 0;
        };
      };
}
