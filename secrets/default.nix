{ lib, config, pkgs, sops-nix, ... }:
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
    };

    age = {
      keyFile = "/var/lib/sops/key.txt";
      generateKey = true;
      sshKeyPaths = [ ];
    };

    gnupg.sshKeyPaths = [ ];
  };

  nixsvc.activateHooks = let
    cfg = config.sops;
  in
  {
    generateAgeKey = with lib; mkIf (cfg.age.generateKey) (stringAfter [] ''
      if [[ ! -f '${cfg.age.keyFile}' ]]; then
        echo generating machine-specific age key...
        mkdir -p $(dirname ${cfg.age.keyFile})
        # age-keygen sets 0600 by default, no need to chmod.
        ${pkgs.age}/bin/age-keygen -o ${cfg.age.keyFile}
      fi
    '');

    setupSecrets = lib.stringAfter [ "generateAgeKey" ] ''
      # Setup secrets
      echo ${config.system.build.sops-nix-manifest}
    '';

    startUnits.deps = [ "setupSecrets" ];
  };
}
