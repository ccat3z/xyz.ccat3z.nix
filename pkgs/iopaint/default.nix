{ misc
, cudaSupport ? true
, cudaPackages
, ...
}:
misc.evalDream ./. (
  { config, lib, dream2nix, ... }: {
    imports = [
      dream2nix.modules.dream2nix.pip
    ];

    deps = { nixpkgs, ... }: {
      python = nixpkgs.python311;
    };

    name = "iopaint";
    version = "1.2.3";

    buildPythonPackage = {
      pythonImportsCheck = [
        config.name
      ];
      format = "wheel";
      makeWrapperArgs = lib.mkIf cudaSupport [
        "--set"
        "LD_LIBRARY_PATH"
        "${lib.makeLibraryPath [cudaPackages.cudatoolkit cudaPackages.cudnn]}"
      ];
    };

    pip = {
      pypiSnapshotDate = "2024-04-14";
      requirementsList = [ "${config.name}==${config.version}" ];
    };
  }
)
