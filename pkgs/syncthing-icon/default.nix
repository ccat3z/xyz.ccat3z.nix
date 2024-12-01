{ pkgs, stdenvNoCC, glib, fetchFromGitHub, ... }:
let
  uuid = "syncthingicon@jay.strict@posteo.de";
  pname = "syncthing-icon";
  version = "35";
in
stdenvNoCC.mkDerivation {
  pname = "gnome-shell-extension-${pname}";
  version = builtins.toString version;

  src = fetchFromGitHub {
    owner = "jaystrictor";
    repo = "gnome-shell-extension-syncthing";
    rev = "v${version}";
    hash = "sha256-bp/ggEVF5kbWlPeQXDarIC2+5BR9HhrnxGKuOJmcfmQ=";
  };

  patches = [
    ./port-46.patch
    ./port-47.patch
    ./default-dir.patch
  ];

  buildPhase = ''
    runHook preBuild

    ${glib.dev}/bin/glib-compile-schemas schemas/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/gnome-shell/extensions/${uuid}
    cp -r src/* icons schemas $out/share/gnome-shell/extensions/${uuid}/
    cp ${./syncthing-symbolic.svg} $out/share/gnome-shell/extensions/${uuid}/icons/hicolor/symbolic/apps/syncthing-symbolic.svg

    runHook postInstall
  '';
}

