{ lib, config, pkgs, ... }:
let
  hasNebulaConfig = config.sops.secrets ? "nebula.yaml";
  nebulaConfig = config.sops.secrets."nebula.yaml".path;
  nebula = pkgs.nebula;
in
lib.mkIf hasNebulaConfig
{
  systemd.services.nebula = {
    description = "Nebula VPN service";
    wants = [ "basic.target" ];
    after = [ "basic.target" "network.target" ];
    before = [ "sshd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "notify";
      Restart = "always";
      ExecStart = "${nebula}/bin/nebula  -config ${nebulaConfig}";
      UMask = "0027";
      CapabilityBoundingSet = "CAP_NET_ADMIN";
      AmbientCapabilities = "CAP_NET_ADMIN";
      LockPersonality = true;
      NoNewPrivileges = true;
      PrivateDevices = false; # needs access to /dev/net/tun (below)
      DeviceAllow = "/dev/net/tun rw";
      DevicePolicy = "closed";
      PrivateTmp = true;
      PrivateUsers = false; # CapabilityBoundingSet needs to apply to the host namespace
      ProtectClock = true;
      ProtectControlGroups = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      User = "nebula";
      Group = "nebula";
    };
    unitConfig.StartLimitIntervalSec = 0; # ensure Restart=always is always honoured (networks can go down for arbitrarily long)
  };

  users.users.nebula = {
    group = "nebula";
    description = "Nebula service user";
    isSystemUser = true;
  };
  users.groups.nebula = { };
}
