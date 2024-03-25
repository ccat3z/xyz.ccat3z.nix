{ config, lib, ... }:
let
  device = "/dev/disk/by-uuid/562eab94-9110-469b-9ff6-21ac246a4748";

  inherit (config) myUser;
  myGroup = config.users.users.${myUser}.group;

  subvolumes = {
    "/mnt/volume" = "/";
    "/home/${myUser}/Documents" = "project";
    "/home/${myUser}/Database" = "database";
    "/home/${myUser}/.cache" = "nix/cache";
    "/var/lib/syncthing" = "nix/syncthing";
    "/var/lib/docker" = "nix/docker";
    "/var/lib/libvirt" = "nix/libvirt";
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
  fileSystems = lib.listToAttrs (lib.mapAttrsToList mkFsCfg subvolumes);

  systemd.tmpfiles.rules = [
    "z /home/${myUser}/.cache 0755 ${myUser} ${myGroup}"
    "z /var/lib/syncthing     0755 ${myUser} ${myGroup}"
  ];
}
