{ pkgs, stdenvNoCC, ... }:
let
  pname = "translate-label";
  uuid = "${pname}@ccat3z.xyz";
  version = 2;
in
stdenvNoCC.mkDerivation {
  pname = "gnome-shell-extension-${pname}";
  version = builtins.toString version;
  src = ./src;
  patchPhase = ''
    runHook prePatch

    substituteInPlace extension.js \
      --subst-var-by trans ${pkgs.translate-shell}/bin/trans

    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r -T . $out/share/gnome-shell/extensions/${uuid}

    runHook postInstall
  '';
}
