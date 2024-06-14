{ pkgs, lib, config, home-manager, ... }:
let
  user = config.myUser;
in
{
  imports = [
    home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.verbose = true;

      home-manager.users.${user} = import ./.;
    }
    (lib.mkAliasOptionModule [ "my" ] [ "home-manager" "users" user ])
  ];

  users.users.${user}.home = "/Users/${user}";
}
