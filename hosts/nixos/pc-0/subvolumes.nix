{ config, lib, ... }:
let
  inherit (config) myUser;
  myGroup = config.users.users.${myUser}.group;

  volumeDir = "/mnt/volume";
  snapshotDir = "/mnt/volume/.snapshots-nixos";
  backupDir = "/mnt/volume/.snapshots-nixos";
in
{
  # Subvol in rootfs
  systemd.tmpfiles.rules = [
    "v /home/${myUser}/.cache    0755 ${myUser} ${myGroup}"
    "v /home/${myUser}/Downloads 0755 ${myUser} ${myGroup}"
    "v /var/lib/syncthing        0755 ${myUser} ${myGroup}"
    "v /var/lib/docker           0700 :root :root"
    "v /var/lib/libvirt          0700 :root :root"
    "v /var/lib/postgresql       0700 :root :root"
    "v /var/backup/postgresql    0700 :root :root"
  ];

  # Subvol out of rootfs
  fileSystems =
    let
      device = config.fileSystems."/".device;
      subvols = {
        "${volumeDir}" = "/";
        "/home/${myUser}/Documents" = "project";
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
  services.btrbk.instances.default = {
    onCalendar = "daily";
    settings = {

      snapshot_preserve_min = "latest";
      snapshot_preserve = "3d";
      snapshot_dir = snapshotDir;

      target_preserve_min = "no";
      target_preserve = "no";
      target = backupDir;

      volume."/mnt/volume" = {
        subvolume = {
          "nix/rootfs" = { };
          "project" = { };
          "database" = { };
        };
      };
      subvolume = {
        "/var/lib/syncthing" = { };
        "/var/lib/docker" = { };
        "/var/lib/libvirt" = { };
        "/var/backup/postgresql" = {
          target_preserve_min = "latest";
          target_preserve = "2w 3d";
        };
      };
    };
  };
}
