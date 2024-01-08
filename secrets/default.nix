{ sops-nix, ... }:
{
  imports = [
    sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ./keys.yaml;
  sops.secrets."users/password" = {
    neededForUsers = true;
  };
}