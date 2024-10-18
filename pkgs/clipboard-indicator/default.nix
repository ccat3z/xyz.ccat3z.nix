{ pkgs, stdenvNoCC, fetchFromGitHub, glib, unzip, zip, gnome, ... }:
let
  name = "clipboard-indicator";
  uuid = "${name}@tudmotu.com";
  rev = "08855b144b2e2e9163d6d8a99d6f8e81a88f1a5d";
  hash = "sha256-CBOsfJpmj+BTmXqTu5GtTNwpUuf9oAmO4J7RLLPFINw=";
in
stdenvNoCC.mkDerivation {
  name = "gnome-shell-extension-${name}";

  src = fetchFromGitHub {
    owner = "Tudmotu";
    repo = "gnome-shell-extension-clipboard-indicator";
    inherit rev hash;
  };

  dontBuild = true;

  patches = [ ./style.patch ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/
    cp -r . -d $out/share/gnome-shell/extensions/${uuid}
    runHook postInstall
  '';
}
