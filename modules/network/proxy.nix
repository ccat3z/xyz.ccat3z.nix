{ pkgs, lib, config, ... }:
let
  inherit (pkgs) v2ray tproxy-helper;
in
{
  options.services.proxy.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = {
    environment.systemPackages = [
      v2ray
      tproxy-helper
    ];

    systemd.packages = with pkgs; [ v2ray ];
    systemd.services.v2ray = {
      wantedBy = if config.services.proxy.enable then [ "multi-user.target" ] else [ ];
      preStart = "${lib.getExe tproxy-helper} up";
      preStop = "${lib.getExe tproxy-helper} down";
      serviceConfig = {
        # https://github.com/NixOS/nixpkgs/issues/63703#issuecomment-504836857
        ExecStart = [
          ""
          "${lib.getBin v2ray}/bin/v2ray run -config ${config.sops.secrets."v2ray.yaml".path}"
        ];
      };
    };
  };
}
