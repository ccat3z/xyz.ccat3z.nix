{ dream2nix, nixpkgs, ... }:
{
  evalDream = path: module: dream2nix.lib.evalModules {
    packageSets.nixpkgs = nixpkgs;
    modules = [
      module
      {
        paths.projectRoot = ../.;
        paths.projectRootFile = "flake.nix";
        paths.package = path;
      }
    ];
  };
}
