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
    enable = false; # FIXME: Peer authentication failed for user "miniflux"
    config = {
      ADMIN_USERNAME = "ccat3z";
      LISTEN_ADDR = "127.0.0.1:3741";
    };
    adminCredentialsFile = config.sops.secrets."miniflux.env".path;
  };
  sops.secrets."miniflux.env" = {
    sopsFile = ./miniflux.env;
    format = "binary";
    mode = "0444";
  };
  services.nginx.virtualHosts."rss.ccat3z.xyz".locations."/".proxyPass = "http://127.0.0.1:3741";
  # Wait a while for postgresql to notice dynamic user.
  # systemd.services.miniflux.serviceConfig.ExecStartPre = [ "${pkgs.coreutils-full}/bin/sleep 5" ];

  # RSSHub
  virtualisation.oci-containers.containers = {
    "rsshub" = rec {
      imageFile = pkgs.dockerTools.pullImage {
        imageName = "diygod/rsshub";
        # 2024-11-08 See: https://hub.docker.com/r/diygod/rsshub/tags
        imageDigest = "sha256:978a21afccd1ef2aba55395d4d5bfe8e383efa122d949b24a110033b00c53c53";
        sha256 = "sha256-u/SC9tOytsD+0LS3HAm8xObV0+K5PvgzW/HFJ8FlnjE=";
      };
      image = "diygod/rsshub";
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
