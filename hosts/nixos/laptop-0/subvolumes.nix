{ config, lib, ... }:
let
  inherit (config) myUser;
  myGroup = config.users.users.${myUser}.group;

  volumeDir = "/mnt/volume";
  snapshotDir = "/mnt/volume/.snapshots-nixos";
  backupDir = "/mnt/backup/backup_${config.networking.hostName}";
in
{
  # Subvol in rootfs
  systemd.tmpfiles.rules = [
    "v /home/${myUser}/.cache    0755 ${myUser} ${myGroup}"
    "v /home/${myUser}/Downloads 0755 ${myUser} ${myGroup}"
    "v /var/lib/syncthing        0755 ${myUser} ${myGroup}"
    "v /var/lib/docker           0700 :root :root"
    "v /var/lib/libvirt          0755 :root :root"
  ];

  # Subvol out of rootfs
  fileSystems =
    let
      device = config.fileSystems."/".device;
      subvols = {
        "${volumeDir}" = "/";
        "/home/${myUser}/Documents" = "projects";
        "/home/${myUser}/Database" = "database";
      };
      mkFsCfg = path: subvol: {
        name = path;
        value = {
          inherit device;
          fsType = "btrfs";
          options = [ "rw" "relatime" "ssd" "space_cache=v2" "subvol=${subvol}" "nofail" ];
        };
      };
    in
    lib.listToAttrs (lib.mapAttrsToList mkFsCfg subvols);

  # Backup
  services.btrbk.instances.btrbk =
    let
      snapshotOnly = {
        target_preserve_min = "no";
        target_preserve = "no";
      };
      twoWeek = {
        target_preserve_min = "latest";
        target_preserve = "2w 7d";
      };
    in
    {
      onCalendar = "daily";
      settings = {

        snapshot_preserve_min = "latest";
        snapshot_preserve = "3d";
        snapshot_dir = snapshotDir;

        target = backupDir;

        volume."/mnt/volume" = {
          subvolume = {
            "nixos/rootfs" = snapshotOnly;
            "projects" = twoWeek;
            "database" = snapshotOnly;
          };
        };
        subvolume = {
          "/var/lib/syncthing" = twoWeek;
          "/var/lib/docker" = snapshotOnly;
          "/var/lib/libvirt" = twoWeek;
        };
      };
    };
}
