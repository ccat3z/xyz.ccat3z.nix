{ super, fetchpatch, ... }:
super.gnome.overrideScope' (selfGnome: superGnome: {
    mutter = superGnome.mutter.overrideAttrs {
        patches = fetchpatch {
            url = "https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3525.patch";
            hash = "sha256-/ubAWUqcyl+JfKgAt6dG3MFFlzqj1j7qcPpr+YHDhRA=";
        };
    };
})
