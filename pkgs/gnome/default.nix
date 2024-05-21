{ super, fetchpatch, ... }:
super.gnome.overrideScope' (selfGnome: superGnome: {
  mutter = superGnome.mutter.overrideAttrs {
    # Fix clipboard
    patches = fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3551.patch";
      hash = "sha256-LO1fF/wup9YUOqsnJEq42PzIrMF4/rVAmtVgMiHqNz4=";
    };
  };
  gnome-shell =
    let
      superGS = superGnome.gnome-shell;
    in
    superGS.overrideAttrs {
      patches = superGS.patches ++ [
        # Required by mutter#3551
        (fetchpatch {
          url = "https://gitlab.gnome.org/tudmotu/gnome-shell/-/commit/2023121660fdfc3caa9baba5fd2ada877511dba3.patch";
          hash = "sha256-zAnQXr7sLyKumH6WV4C4XSCuGbuMLRetiV/L1ok5BLU=";
        })
      ];
    };
})
