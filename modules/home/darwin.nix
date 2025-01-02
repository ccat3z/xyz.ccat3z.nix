{ pkgs, lib, config, home-manager, mac-app-util, ... }:
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

      home-manager.sharedModules = [ mac-app-util.homeManagerModules.default ];
    }
    (lib.mkAliasOptionModule [ "my" ] [ "home-manager" "users" user ])
  ];

  users.users.${user}.home = "/Users/${user}";
}
