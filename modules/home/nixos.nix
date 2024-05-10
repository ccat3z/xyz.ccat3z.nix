# NixOS Module for home
{ pkgs, lib, config, home-manager, ... }:
let
  user = config.myUser;

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
    (lib.mkAliasOptionModule [ "my" ] [ "home-manager" "users" user ])
    wiresharkConfig
  ];

  programs.zsh.enable = true;
  users.users.${user}.shell = pkgs.zsh;

  # Required by host-spawn
  services.flatpak.enable = true;

  # Spice
  virtualisation.spiceUSBRedirection.enable = true;
}
