{ lib, config, sops-nix, ... }:
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./keys.yaml;
    secrets = {
      "users/password" = { neededForUsers = true; };
      "v2ray.yaml" = {
        sopsFile = ./v2ray.yaml.enc;
        format = "binary";
        mode = "0444";
      };
    };

    age = {
      keyFile = "/var/lib/sops/key.txt";
      generateKey = true;
      sshKeyPaths = [ ];
    };

    gnupg.sshKeyPaths = [ ];
  };
}
