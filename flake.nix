{
  description = "ccat3z's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    # override the default substituters
    substituters = [
      # cache mirror located in China
      # status: https://mirror.sjtu.edu.cn/
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      # status: https://mirrors.ustc.edu.cn/status/
      # "https://mirrors.ustc.edu.cn/nix-channels/store"

      "https://cache.nixos.org"
    ];
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      hostsModules =
        type:
        let
          inherit (nixpkgs) lib;
          inherit (builtins) listToAttrs attrNames readDir;
        in
        listToAttrs (map
          (x:
          let
            hostName = lib.strings.removeSuffix ".nix" x;
          in
          {
            name = hostName;
            value = (./hosts + "/${type}/${x}");
          })
          (attrNames (readDir ./hosts/${type})));
    in
    {
      inherit inputs;

      packages = forAllSystems (sys: import ./pkgs { nixpkgs = nixpkgs.legacyPackages.${sys}; });

      # Export all pkgs
      legacyPackages = forAllSystems (sys: import "${nixpkgs}" { system = sys; });

      overlays.default = import ./pkgs/overlay.nix;

      nixosConfigurations = (
        let
          inherit (nixpkgs) lib;
          inherit (builtins) mapAttrs;
          base = {
            specialArgs = {
              inherit (inputs) sops-nix home-manager nixpkgs-unstable;
            };
            modules = [
              ./modules/nixos
              ./secrets
              ./modules/home/nixos.nix
              {
                nixpkgs.overlays = [ self.overlays.default ];
                home.user = "ccat3z";
                networking.domain = "ccat3z.xyz";
              }
            ];
          };
        in
        mapAttrs
          (hostName: hostModule: (
            lib.nixosSystem (base // {
              modules = base.modules ++ [
                hostModule
                { networking.hostName = hostName; }
              ];
            })
          ))
          (hostsModules "nixos")
      );

      nixsvcProfiles =
        let
          inherit (nixpkgs) lib;
          inherit (builtins) mapAttrs;
        in
        mapAttrs
          (hostName: hostModule: (
            nixpkgs.lib.evalModules {
              modules = [
                {
                  config = {
                    networking.hostName = hostName;
                    networking.domain = "ccat3z.xyz";
                  };
                }
                ./secrets
                ./modules/nixsvc
                hostModule
                ({ nixpkgs.overlays = [ self.overlays.default ]; })
              ];
              specialArgs = {
                inherit (inputs) sops-nix nixpkgs;
              };
            }
          ))
          (hostsModules "nixsvc");

      formatter = forAllSystems (sys: nixpkgs.legacyPackages.${sys}.nixpkgs-fmt);

      devShells = forAllSystems (
        sys:
        let
          pkgs = nixpkgs.legacyPackages.${sys};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              sops
              gnupg
              age
            ];
          };
        }
      );
    };
}
