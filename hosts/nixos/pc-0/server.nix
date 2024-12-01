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
    databases = [ "immich" ];
    startAt = "*-*-* 23:00:00";
  };

  # Immich
  services.immich-docker = {
    enable = true;
    port = 3187;
    storagePath = "/var/lib/immich";
  };
  services.nginx.virtualHosts."immich.ccat3z.xyz" = {
    http2 = true;
    locations."/".proxyPass = "http://127.0.0.1:${builtins.toString config.services.immich-docker.port}";

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
