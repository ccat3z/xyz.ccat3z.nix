{ config, pkgs, ... }:
let
  sshAuthorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC78zZLsyWn/h6q043x0hKK3VsK0As0YzJH61LX+wU11tttucWU0ES5i6O2qU4EpZAAfHR5H/vNvPVbupmG/MSi6eCJ/DOhpwoC4STt7y96P3Pw5daNijUNPcxrOLP1sp9CvAg9VEtvl74kIJEdn1HGUStyid4xOGafsJnE8C+SS+gshEW2zkhghg5Xoxm+s2PpPVjrUUWYBCUDZWa1Zb7pN9S/lPnHN72NcXOE12+o+fHHEPgBPovWEE0407jg8pOLH7JxuQIRQLxCmHEsN9Ikt9KG5WTtq70SDMoGnRCZJBj8qrF6ZFeUoFFDLj/olQqDKA9mpI1m9NPGHaCcGvRn openpgp:0xC98E1B0F"
  ];
in
{
  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPasswordFile = config.sops.secrets."users/password".path;
      openssh.authorizedKeys = sshAuthorizedKeys;
    };
    ccat3z = {
      isNormalUser = true;
      group = "users";
      extraGroups = [ "wheel" "docker" ];
      hashedPasswordFile = config.sops.secrets."users/password".path;
      openssh.authorizedKeys = sshAuthorizedKeys;
    };
  };
}
