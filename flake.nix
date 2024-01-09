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
        ({ nixpkgs.overlays = [ self.overlays.default ]; })
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

    packages.x86_64-linux = import ./pkgs { pkgs = nixpkgs.legacyPackages.x86_64-linux; };
    overlays.default = import ./pkgs/overlay.nix;

    devShells.x86_64-linux.default =
      let
        pkgs = import nixpkgs { system = "x86_64-linux"; overlays = [ self.overlays.default ]; };
      in
      pkgs.mkShell {
        packages = with pkgs; [
          sops
          gnupg
        ];

        shellHook = ''
          echo -e '\033[34mIn dev shell\033[0m' >&2
          exec $SHELL
        '';
      };
  };
}
