{ nixpkgs-unstable, config, lib, ... }:
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

  use = nixpkgs: pkgsNames:
    let
      pkgs = pkgsInstance nixpkgs;
    in
    with builtins; listToAttrs (map
      (n: {
        name = n;
        value = pkgs.${n};
      })
      pkgsNames
    );
in
{
  nixpkgs.overlays = [ (self: super: use nixpkgs-unstable [ "devenv" ]) ];
}
