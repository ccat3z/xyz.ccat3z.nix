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
    in
    {
      nixosConfigurationsBase = {
        inherit system;
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
          (x:
            let
              hostName = lib.strings.removeSuffix ".nix" x;
            in
            {
              name = hostName;
              value = lib.nixosSystem (base // {
                modules = base.modules ++ [
                  (./hosts + ("/" + x))
                  {
                    networking.hostName = hostName;
                    networking.domain = "ccat3z.xyz";
                  }
                ];
              });
            })
          (attrNames (readDir ./hosts)))
      );

      formatter.${system} = pkgs.nixpkgs-fmt;

      packages.${system} = import ./pkgs { inherit pkgs; };
      overlays.default = import ./pkgs/overlay.nix;

      devShells.${system}.default =
        let
          pkgs = import nixpkgs { inherit system; overlays = [ self.overlays.default ]; };
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
