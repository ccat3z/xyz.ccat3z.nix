{ pkgs, lib, config, ... }:
let
  pgsql = {
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
    };
    services.postgresqlBackup = {
      enable = true;
      databases = [ "miniflux" ];
      startAt = "*-*-* 23:00:00";
    };
  };
  miniflux = {
    # miniflux module will setup postgresql implicitly
    services.miniflux = {
      enable = true;
      config = {
        ADMIN_USERNAME = "ccat3z";
        LISTEN_ADDR = "127.0.0.1:3741";
      };
      adminCredentialsFile = "/etc/miniflux/env";
    };
  };
in
{
  # systemd-nspawn containers
  containers.server = {
    config = lib.mkMerge [
      pgsql
      miniflux
      { system.stateVersion = "23.11"; }
      {
        networking.hosts."127.0.0.1" = [ "rsshub.local" ];
      }
    ];
    bindMounts = {
      data = {
        mountPoint = "/var/lib/postgresql";
        hostPath = "/var/lib/postgresql";
        isReadOnly = false;
      };
      backup = {
        mountPoint = "/var/backup/postgresql";
        hostPath = "/var/backup/postgresql";
        isReadOnly = false;
      };
      minifluxCredentialsFile = {
        mountPoint = "/etc/miniflux/env";
        hostPath = config.sops.secrets."miniflux/env".path;
        isReadOnly = true;
      };
      # https://discourse.nixos.org/t/dns-in-declarative-container/1529
      "/etc/resolv.conf" = {
        hostPath = "/etc/resolv.conf";
        isReadOnly = true;
      };  
    };
    autoStart = true;
  };
  services.nginx.virtualHosts."rss.ccat3z.xyz".locations."/".proxyPass = "http://127.0.0.1:3741";

  # oci containers
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    "rsshub" = {
      image = "diygod/rsshub:latest";
      autoStart = true;
      extraOptions = [ "--network=host" ];
      environment = {
        PORT = "1200";
      };
      ports = [ "127.0.0.1:1200:1200" ];
    };
  };
  services.nginx.virtualHosts."rsshub.local".locations."/".proxyPass = "http://127.0.0.1:1200";
  networking.hosts."127.0.0.1" = [ "rsshub.local" ];

  # gateway
  services.nginx.enable = true;
  services.nginx.virtualHosts."gallery.ccat3z.xyz".locations."/".proxyPass = "http://127.0.0.1:3012";
}
