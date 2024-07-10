{ lib, config, sops-nix, ... }:
let
  encNebulaConfig = ./nebula/${config.networking.hostName}.yaml.enc;
  enableNebula = builtins.pathExists encNebulaConfig;
in
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
      "nebula.yaml" = lib.mkIf enableNebula {
        sopsFile = encNebulaConfig;
        format = "binary";
        mode = "0444";
      };
      "nebula/ssh_host_key" = lib.mkIf enableNebula {
        mode = "0444";
        path = "/etc/nebula/ssh_host_ed25519_key";
      };
      "laptop-0_ssh_config" = {
        sopsFile = ./laptop-0_ssh_config.enc;
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
