# Immich - Self-hosted photos and videos.
#
# This file adapted from Andrew Morgan's dotfiles:
# https://github.com/anoadragon453/dotfiles/blob/c4e1aa4ea7196713d87c0250c86217f43c0d9e3e/modules/server/immich.nix
#
{ config, lib, pkgs, ... }:
let
  cfg = config.services.immich;
in
{
  options.services.immich = {
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
              "sha256:9ef9d53759126ec884689d4f554096dd5f6f6e0189fda3d43a264f8a40996987"; # v1.108.0
            sha256 = "sha256-bsXuWRxJKsL5pHUN0aEduzyLissg7w3Orx30/cnM8yI=";
          };
          machineLearning = {
            imageName = "ghcr.io/immich-app/immich-machine-learning";
            imageDigest =
              "sha256:bcbfad794b8a9a8a6154b08d3dd42bf399bf3096767b93e08a3a0c15bf612b0a"; # v1.108.0
            sha256 = "sha256-x8qTfiS+x3I/un0OtDq05RT+sHqBYY+06N0OoXSvDNw=";
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

            ports = [ "${toString cfg.port}:3001" ];

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
