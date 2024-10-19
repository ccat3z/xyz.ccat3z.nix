{ pkgs, stdenvNoCC, ... }:
let
  pname = "extend-left-box";
  uuid = "${pname}@ccat3z.xyz";
  version = 1;
in
stdenvNoCC.mkDerivation {
  pname = "gnome-shell-extension-${pname}";
  version = builtins.toString version;
  src = ./src;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r -T . $out/share/gnome-shell/extensions/${uuid}

    runHook postInstall
  '';
}
