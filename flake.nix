{
  description = "ccat3z's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dream2nix = {
      url = "github:nix-community/dream2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jovian-nixos = {
      url = "github:ccat3z/Jovian-NixOS/24.11-backport";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin inputs
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    mac-app-util = {
      url = "github:hraban/mac-app-util";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
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

  outputs = { self, nixpkgs, dream2nix, nix-darwin, ... }@inputs:
    let
      systems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
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

      nixpkgConfig = {
        allowUnfree = true;
      };
    in
    {
      inherit inputs;

      # Export all pkgs
      legacyPackages = forAllSystems (sys: import "${nixpkgs}" {
        system = sys;
        config = nixpkgConfig;
        overlays = [ self.overlays.default ];
      });

      overlays.default = import ./pkgs/overlay.nix {
        inherit dream2nix;
      };

      nixosConfigurations =
        builtins.mapAttrs
          (hostName: hostModule: (
            nixpkgs.lib.nixosSystem ({
              specialArgs = {
                inherit (inputs)
                  sops-nix home-manager nixpkgs-unstable
                  jovian-nixos nixpkgs-sd;
              };
              modules = [
                ./modules/nixos
                ./secrets
                ./modules/home/nixos.nix
                {
                  nixpkgs.overlays = [ self.overlays.default ];
                  networking.domain = "ccat3z.xyz";

                  # Add this flake to system registry
                  nix.channel.enable = false;
                  nix.settings.flake-registry = "";
                  nix.registry = {
                    nixpkgs.flake = nixpkgs;
                    ccat3z.to = {
                      type = "path";
                      path = ./.;
                    };
                  };

                  # Nixpkg config
                  nixpkgs.config = nixpkgConfig;

                  networking.hostName = hostName;
                }
                hostModule
              ];
            })
          ))
          (hostsModules "nixos")
      ;

      darwinConfigurations =
        let
          inherit (nixpkgs) lib;
          inherit (builtins) mapAttrs;
        in
        mapAttrs
          (hostName: hostModule: (
            nix-darwin.lib.darwinSystem {
              modules = [
                {
                  config = {
                    nixpkgs.overlays = [
                      inputs.nixpkgs-firefox-darwin.overlay
                      self.overlays.default
                    ];
                    nix.settings.flake-registry = "";
                    nix.registry.ccat3z.to = {
                      type = "path";
                      path = "${./.}";
                    };
                  };
                }
                # ./secrets
                ./modules/darwin
                ./modules/home/darwin.nix
                hostModule
              ];
              specialArgs = {
                inherit (inputs) sops-nix home-manager nixpkgs-unstable mac-app-util;
              };
            }
          ))
          (hostsModules "darwin");

      formatter = forAllSystems (sys: nixpkgs.legacyPackages.${sys}.nixpkgs-fmt);

      apps = forAllSystems (sys:
        let
          pkgs = nixpkgs.legacyPackages.${sys};
          appsList = builtins.map
            (d: {
              name = d.name;
              value = { type = "app"; program = "${d}/bin/${d.name}"; };
            })
            [
              (import ./secrets/updatekeys.nix { inherit pkgs; inherit (self) nixosConfigurations; })
            ];
        in
        builtins.listToAttrs appsList);

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
