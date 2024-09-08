{ nixpkgs-sd, config, lib, ... }:
let
  pkgsInstance = nixpkgs:
    let
      cfg = config.nixpkgs;
      isCross = cfg.buildPlatform != cfg.hostPlatform;
      systemArgs =
        if isCross
        then {
          localSystem = cfg.buildPlatform;
          crossSystem = cfg.hostPlatform;
        }
        else {
          localSystem = cfg.hostPlatform;
        };
    in
    import "${nixpkgs}" ({
      inherit (cfg) config;
    } // systemArgs);

  use = nixpkgs: hostPlatform: pkgsNames:
    let
      pkgs = pkgsInstance nixpkgs;
      system = hostPlatform.system;
    in
    with builtins; listToAttrs (map
      (n: {
        name = n;
        value =
          if system == "x86_64-linux" then pkgs.${n}
          else if system == "i686-linux" then pkgs.pkgsi686Linux.${n}
          else throw "unsupport system ${system}";
      })
      pkgsNames
    );
in
{
  nixpkgs.overlays = lib.mkBefore [
    (self: super: use nixpkgs-sd super.stdenv.hostPlatform [
      "linux-firmware"
      "gamescope"
      "steamPackages"
    ])
  ];
}
