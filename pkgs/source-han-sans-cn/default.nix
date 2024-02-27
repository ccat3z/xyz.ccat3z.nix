{ lib
, stdenvNoCC
, fetchurl
, unzip
}:
let
  rev = "2.004R";
  hash = "sha256-aEH8E/HA0lXP6zPSosaNJLvr2UriwHA0eisrIAodtNY=";
in
stdenvNoCC.mkDerivation rec {
  pname = "source-han-sans-cn";
  version = lib.removeSuffix "R" rev;

  src = fetchurl {
    url = "https://github.com/adobe-fonts/source-han-sans/releases/download/${rev}/SourceHanSansCN.zip";
    inherit hash;
  };

  nativeBuildInputs = [ unzip ];

  unpackPhase = ''
    unzip $src
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 SubsetOTF/CN/*.otf -t $out/share/fonts/opentype/${pname}

    runHook postInstall
  '';

  meta = {
    description = "An open source Pan-CJK typeface";
    homepage = "https://github.com/adobe-fonts/source-han-sans";
    license = lib.licenses.ofl;
  };
}
