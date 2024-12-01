{ super, fetchpatch }:
super.fan2go.overrideAttrs {
  patches = [
    (
      fetchpatch {
        url = "https://github.com/markusressel/fan2go/commit/8be8aad7d02b19214147afe9b861021bd8499613.patch";
        hash = "sha256-/gyoawG8si/ASeIIVj69bRwISdxvkVKZ7DWXQj0s/jo=";
      }
    )
  ];
}
