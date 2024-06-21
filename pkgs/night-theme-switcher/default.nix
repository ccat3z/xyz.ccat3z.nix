{ stdenvNoCC, fetchFromGitLab, meson, ninja, glib, ... }:
let
  version = "77";
in
stdenvNoCC.mkDerivation {
  pname = "night-theme-switcher";
  version = "77";

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "nightthemeswitcher-gnome-shell-extension";
    rev = version;
    hash = "sha256-OWnmjsKpw+82KUMkGK8yA13AGolTHJfmjxFp0qY0jcY=";
  };

  patches = [ ./revert-theme-switcher.patch ];

  nativeBuildInputs = [
    glib.dev
    meson
    ninja
  ];
}