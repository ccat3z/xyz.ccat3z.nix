{
  description = "ccat3z's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, sops-nix, ... }@inputs: {
    nixosConfigurations = rec {
      base = {
        system = "x86_64-linux";
        specialArgs = {
          inherit sops-nix;
        };
        modules = [
          ./modules
          ./secrets
        ];
      };
      libvirtd = nixpkgs.lib.nixosSystem (base // {
        modules = base.modules ++ [ ./hosts/libvirtd.nix ];
      });
    };
  };
}