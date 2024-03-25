{ config, lib, ... }:
let
  inherit (config) myUser;
  myGroup = config.users.users.${myUser}.group;

  device = "/dev/disk/by-uuid/562eab94-9110-469b-9ff6-21ac246a4748";
  subvolOutOfRoot = {
    "/mnt/volume" = "/";
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
{
  fileSystems = lib.listToAttrs (lib.mapAttrsToList mkFsCfg subvolOutOfRoot);

  # Subvol in rootfs
  systemd.tmpfiles.rules = [
    "v /home/${myUser}/.cache    0755 ${myUser} ${myGroup}"
    "v /home/${myUser}/Downloads 0755 ${myUser} ${myGroup}"
    "v /var/lib/syncthing        0755 ${myUser} ${myGroup}"
    "v /var/lib/docker           0700 root root"
    "v /var/lib/libvirt          0700 root root"
  ];
}
