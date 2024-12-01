{ pkgs, buildNpmPackage, fetchFromGitHub, ... }:
let
  uuid = "rounded-window-corners@fxgn";
in
buildNpmPackage {
  pname = "rounded-window-corners";

  src = fetchFromGitHub {
    owner = "flexagoon";
    repo = "rounded-window-corners";
    rev = "c98ca5082e95aa3b9c976180843336d7e03904e5";
    hash = "sha256-CKePsjcywC86WlDqaGOY8VKbVT4HSvxCa1NRrjS65FM=";
  };
  version = "20241127";
  npmDepsHash = "sha256-Xce5b/X3R1IE1b7RY9l7HgZ1TVAqq2b3hLETo14xks8=";

  nativeBuildInputs = with pkgs; [
    glib.dev
    just
  ];

  dontNpmBuild = true;

  buildPhase = ''
    runHook preBuild
    just build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions
    cp -rT _build $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
