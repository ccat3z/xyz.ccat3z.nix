{ lib
, stdenvNoCC
, fetchFromGitHub
}:
let
  commit = "b3e935355afcfb5240bac5a99707ffecc35772a2";
  hash = "sha256-oRVREnE3qsk4gl1W0yFC11bHr+cmuOJe9Ah+0Csplq8=";
in
stdenvNoCC.mkDerivation rec {
  pname = "ttf-wps-fonts";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "dv-anomaly";
    repo = pname;
    rev = commit;
    inherit hash;
  };

  installPhase = ''
    runHook preInstall

    install -Dm444 *.{ttf,TTF} -t $out/share/fonts/opentype/${pname}

    runHook postInstall
  '';

  meta = {
    description = " Symbol fonts required by wps-office. ";
    homepage = "https://github.com/dv-anomaly/ttf-wps-fonts";
  };
}
