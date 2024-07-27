{ pkgs, nixosConfigurations, ... }:
let
  inherit (pkgs) lib;
  sopsConfigs = lib.mapAttrsFlatten
    (_: x: x.config.sops)
    nixosConfigurations;
  sopsFiles = lib.unique (lib.flatten (builtins.map
    (c: lib.mapAttrsFlatten (_: s: s.sopsFile) c.secrets)
    sopsConfigs));
  sopsFilesRel = builtins.map (lib.path.removePrefix ./..) sopsFiles;
in
pkgs.writeScriptBin "sops-updatekeys" ''
  #! ${pkgs.bash}/bin/bash
  set -e

  ${lib.strings.toShellVar "files" sopsFilesRel}

  for f in "${"$"}{files[@]}"; do
    echo -e "\033[34mUpdating $f\033[0m"
    test -f "$f"
    ${pkgs.sops}/bin/sops updatekeys -y "$f"
  done

  echo -e "\033[32mDone\033[0m"
''
