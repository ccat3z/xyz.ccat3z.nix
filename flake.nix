{
  description = "ccat3z's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: {
    nixosConfigurationsBase = {
      system = "x86_64-linux";
      specialArgs = {
        inherit sops-nix;
      };
      modules = [
        ./modules
        ./secrets
      ];
    };
    nixosConfigurations = (
      let
        inherit (nixpkgs) lib;
        inherit (builtins) listToAttrs attrNames readDir;
        base = self.nixosConfigurationsBase;
      in
      listToAttrs (map
        (x: {
          name = lib.strings.removeSuffix ".nix" x;
          value = nixpkgs.lib.nixosSystem (base // {
            modules = base.modules ++ [ (./hosts + ("/" + x)) ];
          });
        })
        (attrNames (readDir ./hosts)))
    );

    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;
  };
}
