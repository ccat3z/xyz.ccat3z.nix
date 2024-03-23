# NixOS Module for home
{ pkgs, lib, config, home-manager, ... }:
let
  cfg = config.home;
  user = cfg.user;

  wiresharkConfig = {
    users.users.${user}.extraGroups = [ "wireshark" ];
    users.groups.wireshark = { };
    security.wrappers.dumpcap = {
      source = "${pkgs.wireshark}/bin/dumpcap";
      capabilities = "cap_net_raw,cap_net_admin+eip";
      owner = "root";
      group = "wireshark";
      permissions = "u+rx,g+x";
    };
  };
in
{
  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.verbose = true;

      home-manager.users.${user} = import ./.;
    }
  ];

  options.home = {
    user = lib.mkOption {
      type = lib.types.str;
    };
    wireshark.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    module = lib.mkOption {
      type = lib.types.anything;
      default = { };
    };
  };

  config = lib.mkMerge [
    ({
      programs.zsh.enable = true;
      users.users.${cfg.user}.shell = pkgs.zsh;

      # Required by host-spawn
      services.flatpak.enable = true;

      # Define home modules out of home/. Useful for host specfic options.
      home-manager.users.${user} = cfg.module;
    })
    (lib.mkIf cfg.wireshark.enable wiresharkConfig)
  ];
}
