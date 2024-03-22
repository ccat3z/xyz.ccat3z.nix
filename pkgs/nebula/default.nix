{ super, fetchpatch, ... }:
super.nebula.overrideAttrs {
  patches = [
    (fetchpatch {
      url = "https://github.com/slackhq/nebula/pull/1054.patch";
      hash = "sha256-qpZoJ5JkiMfMrfhNK8Vl57LSr5LA3A3eykELQsioT3s=";
    })
  ];
}