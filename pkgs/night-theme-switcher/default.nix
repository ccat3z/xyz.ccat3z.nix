{ stdenvNoCC, fetchFromGitLab, meson, ninja, glib, ... }:
let
  version = "78";
in
stdenvNoCC.mkDerivation {
  pname = "night-theme-switcher";
  inherit version;

  src = fetchFromGitLab {
    owner = "rmnvgr";
    repo = "nightthemeswitcher-gnome-shell-extension";
    rev = version;
    hash = "sha256-bLIuSpqAfczcGaPVN0I30CiLVz+6VjpuM/sOLATFOI8=";
  };

  patches = [ ./revert-theme-switcher.patch ];

  nativeBuildInputs = [
    glib.dev
    meson
    ninja
  ];
}
