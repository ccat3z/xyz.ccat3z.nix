# Immich - Self-hosted photos and videos.
#
# This file adapted from Andrew Morgan's dotfiles:
# https://github.com/anoadragon453/dotfiles/blob/c4e1aa4ea7196713d87c0250c86217f43c0d9e3e/modules/server/immich.nix
#
{ config, lib, pkgs, ... }:
let
  cfg = config.services.immich-docker;
in
{
  options.services.immich-docker = {
    enable = lib.mkEnableOption "Immich";

    port = lib.mkOption {
      type = lib.types.int;
      description = "The port to listen on";
    };

    storagePath = lib.mkOption {
      type = lib.types.path;
      description = "The filepath at which persistent Immich files should be stored";
    };
  };

  config = lib.mkIf cfg.enable
    (
      let
        images = {
          serverAndMicroservices = {
            imageName = "ghcr.io/immich-app/immich-server";
            imageDigest =
              "sha256:851c02f28891f1854c5b5762ee8d2e254e2de528cfe3627b2fbcb37a7f108ff3"; # v1.121.0
            sha256 = "sha256-3IRz7yPkPZ9uWU7MNmv+EVRvDaBSlqQ4bw2W7yFLErI=";
          };
          machineLearning = {
            imageName = "ghcr.io/immich-app/immich-machine-learning";
            imageDigest =
              "sha256:1b8494bb9fe2194f2dc72c4d6b0104e16718f50e8772d54ade57909770816ad1"; # v1.121.0
            sha256 = "sha256-R3NKeNsvShwlolbUFGkvHwoyLlm5fHfFMAQ5f30yLkY=";
          };
        };
        dbUsername = user;

        redisName = "immich";

        user = "immich";
        group = user;
        uid = 15015;
        gid = 15015;

        # A function to build a container volume mount string that maps to the
        # same place in the container as on the host.
        mkMount = dir: "${dir}:${dir}";
      in
      {
        # Create a system user that Immich can run under, allowing for peer
        # authentication to the postgres database.
        users.users.${user} = {
          inherit group uid;
          isSystemUser = true;
        };
        users.groups.${group} = { inherit gid; };

        # Create a postgres database for Immich, and install the pgvecto-rs plugin
        # which we build separately as a custom package (see pkgs/default.nix).
        services.postgresql = {
          ensureUsers = [{
            name = dbUsername;
            ensureDBOwnership = true;
            # Make the "immich" user a superuser such that it can create
            # postgres extensions.
            ensureClauses.superuser = true;
          }];
          ensureDatabases = [ dbUsername ];

          extraPlugins = ps: with ps; [ pgvecto-rs ];
          settings = { shared_preload_libraries = "vectors.so"; };
        };

        # Create a redis server instance specifically for Immich.
        services.redis.servers.${redisName} = {
          inherit user;
          enable = true;
        };

        # Ensure that the directory where photos will be stored exists.
        # TODO: This appear to fail with the following error:
        # fchownat() of /mnt/storagebox/media/immich failed: Permission denied
        #
        # systemd.tmpfiles.rules = [ "d ${cfg.storagePath} 0750 ${user} ${group}" ];

        # Start the OCI containers necessary to run an Immich server.
        # The containers are connected via a bridge network called "immich-bridge".
        virtualisation.oci-containers.containers = {
          immich_server = {
            imageFile = pkgs.dockerTools.pullImage images.serverAndMicroservices;
            image = "ghcr.io/immich-app/immich-server";
            extraOptions =
              [ "--network=immich-bridge" "--user=${toString uid}:${toString gid}" ];

            volumes = [
              "${cfg.storagePath}:/usr/src/app/upload"
              (mkMount "/run/postgresql")
              (mkMount "/run/redis-${redisName}")
            ];

            # Full environment variable docs: https://immich.app/docs/install/environment-variables
            environment = {
              DB_URL = "socket://${dbUsername}:@/run/postgresql?db=${dbUsername}";
              REDIS_SOCKET = config.services.redis.servers.${redisName}.unixSocket;
              UPLOAD_LOCATION = cfg.storagePath;
              IMMICH_MACHINE_LEARNING_URL = "http://immich_machine_learning:3003";
              PUID = toString uid;
              PGID = toString gid;
            };

            ports = [ "${toString cfg.port}:2283" ];

            autoStart = true;
          };

          immich_machine_learning = {
            imageFile = pkgs.dockerTools.pullImage images.machineLearning;
            image = "ghcr.io/immich-app/immich-machine-learning";
            extraOptions = [ "--network=immich-bridge" ];

            volumes = [ "immich-model-cache:/cache" ];

            autoStart = true;
          };
        };

        systemd.services = {
          init-immich-network = {
            description = "Create the network bridge for immich.";
            after = [ "network.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig.Type = "oneshot";
            # We hardcode the docker command here (instead of using ${pkgs.docker}/bin/docker)
            # in order to allow for compatibility with podman's docker wrapper.
            script = ''
              # Put a true at the end to prevent getting non-zero return code, which would
              # otherwise cause the service to fail.
              check=$(/run/current-system/sw/bin/docker network ls | grep "immich-bridge" || true)

              if [ -z "$check" ];
                then /run/current-system/sw/bin/docker network create immich-bridge
                else echo "immich-bridge docker network already exists"
              fi
            '';
          };
        };
      }
    );
}
