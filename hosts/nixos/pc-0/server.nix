{ pkgs, lib, config, ... }:
{
  # Basic
  virtualisation.oci-containers.backend = "docker";
  services.nginx.enable = true;

  # PostgreSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
  };
  services.postgresqlBackup = {
    enable = true;
    databases = [ "miniflux" "immich" ];
    startAt = "*-*-* 23:00:00";
  };

  # miniflux module will setup postgresql implicitly
  services.miniflux = {
    enable = true;
    config = {
      ADMIN_USERNAME = "ccat3z";
      LISTEN_ADDR = "127.0.0.1:3741";
    };
    adminCredentialsFile = config.sops.secrets."miniflux/env".path;
  };
  services.nginx.virtualHosts."rss.ccat3z.xyz".locations."/".proxyPass = "http://127.0.0.1:3741";

  # RSSHub
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

  # Immich
  services.immich = {
    enable = true;
    port = 3187;
    storagePath = "/var/lib/immich";
  };
  services.nginx.virtualHosts."immich.ccat3z.xyz" = {
    http2 = true;
    locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.immich.port}";

    extraConfig = ''
      # Allow uploading media files up to 10 gigabytes in size.
      client_max_body_size 10G;
      # Enable websockets: http://nginx.org/en/docs/http/websocket.html
      proxy_http_version 1.1;
      proxy_set_header   Upgrade    $http_upgrade;
      proxy_set_header   Connection "upgrade";
      proxy_redirect     off;
    '';
  };
}
