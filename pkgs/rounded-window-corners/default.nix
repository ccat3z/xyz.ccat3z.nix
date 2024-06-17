{ pkgs, buildNpmPackage, fetchFromGitHub, ... }:
let
  uuid = "rounded-window-corners@fxgn";
in
buildNpmPackage {
  pname = "rounded-window-corners";

  src = fetchFromGitHub {
    owner = "flexagoon";
    repo = "rounded-window-corners";
    rev = "5021d66232ca0ab7eee7e5fa564d61bb2ee49303";
    hash = "sha256-BkbV2VS/HtRjNeOxwujb75fKxtN4Q+FHpEUKmZbrwoU=";
  };
  version = "20240613";
  npmDepsHash = "sha256-2brE1GlzyHN9G/161aKiuHVVbjrpnN/0FBwuBDg/8W0=";

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
