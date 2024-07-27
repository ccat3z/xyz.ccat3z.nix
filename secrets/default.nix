{ lib, config, sops-nix, ... }:
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ./keys.yaml;
    secrets = {
      "users/password" = { neededForUsers = true; };
      "miniflux/env" = { };
      "v2ray.yaml" = {
        sopsFile = ./v2ray.yaml.enc;
        format = "binary";
        mode = "0444";
      };
      "nebula/ssh_host_key" = {
        mode = "0444";
        path = "/etc/nebula/ssh_host_ed25519_key";
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
