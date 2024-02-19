{ config, pkgs, home-manager, ... }:
let
  sshAuthorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC78zZLsyWn/h6q043x0hKK3VsK0As0YzJH61LX+wU11tttucWU0ES5i6O2qU4EpZAAfHR5H/vNvPVbupmG/MSi6eCJ/DOhpwoC4STt7y96P3Pw5daNijUNPcxrOLP1sp9CvAg9VEtvl74kIJEdn1HGUStyid4xOGafsJnE8C+SS+gshEW2zkhghg5Xoxm+s2PpPVjrUUWYBCUDZWa1Zb7pN9S/lPnHN72NcXOE12+o+fHHEPgBPovWEE0407jg8pOLH7JxuQIRQLxCmHEsN9Ikt9KG5WTtq70SDMoGnRCZJBj8qrF6ZFeUoFFDLj/olQqDKA9mpI1m9NPGHaCcGvRn openpgp:0xC98E1B0F"
  ];
in
{
  imports = [
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.verbose = true;

      home-manager.users.ccat3z = import ./home;
    }
  ];

  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets."users/password".path;
      openssh.authorizedKeys = sshAuthorizedKeys;
    };
    ccat3z = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" "docker" "wireshark" ];
      hashedPasswordFile = config.sops.secrets."users/password".path;
      openssh.authorizedKeys = sshAuthorizedKeys;
      shell = pkgs.zsh;
    };
  };
  users.groups.wireshark = {};
  security.wrappers.dumpcap = {
    source = "${pkgs.wireshark}/bin/dumpcap";
    capabilities = "cap_net_raw,cap_net_admin+eip";
    owner = "root";
    group = "wireshark";
    permissions = "u+rx,g+x";
  };
}
