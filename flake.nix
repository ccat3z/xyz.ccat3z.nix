{
  description = "ccat3z's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    sops-nix.url = "github:Mic92/sops-nix";
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

  outputs = { self, nixpkgs, sops-nix, ... }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs { inherit system; };
      myPkgs = import ./pkgs { nixpkgs = pkgs; };
      allPkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };

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

      packages.${system} = myPkgs;

      overlays.default = import ./pkgs/overlay.nix;

      nixosConfigurations = (
        let
          inherit (nixpkgs) lib;
          inherit (builtins) mapAttrs;
          base = {
            inherit system;
            specialArgs = {
              inherit sops-nix;
            };
            modules = [
              ./modules/nixos
              ./secrets
              ({ nixpkgs.overlays = [ self.overlays.default ]; })
            ];
          };
        in
        mapAttrs
          (hostName: hostModule: (
            lib.nixosSystem (base // {
              modules = base.modules ++ [
                hostModule
                {
                  networking.hostName = hostName;
                  networking.domain = "ccat3z.xyz";
                }
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
            self.packages.${system}.nixsvc-profile {
              modules = [
                {
                  config = {
                    networking.hostName = hostName;
                    networking.domain = "ccat3z.xyz";
                  };
                }
                ./secrets
                ./modules/system-units-profile
                hostModule
              ];
              specialArgs = {
                inherit sops-nix;
                modulesPath = "${nixpkgs}/nixos/modules";
                pkgs = allPkgs;
              };
            }
          ))
          (hostsModules "nixsvc");

      formatter.${system} = allPkgs.nixpkgs-fmt;

      devShells.${system}.default =
        let
          pkgs = allPkgs;
        in
        pkgs.mkShell {
          packages = with pkgs; [
            sops
            gnupg
            age
          ];

          shellHook = ''
            echo -e '\033[34mIn dev shell\033[0m' >&2
            exec $SHELL
          '';
        };
    };
}
