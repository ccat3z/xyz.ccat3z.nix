{ stdenv, fetchFromGitHub, hidapi, pkg-config, udev, ... }:
stdenv.mkDerivation {
  name = "hidapitester";

  buildInputs = [ hidapi pkg-config udev ];

  makeFlags = [ "PREFIX=$(out) " ];

  src = fetchFromGitHub {
    owner = "todbot";
    repo = "hidapitester";
    rev = "9e2ccf1118fda629a122d70f04ab2155caa9f4fd";
    hash = "sha256-6Wq45RIDTkJLbMjzmogumyrfYuS3ib4ygYRewLr0+E4=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp hidapitester $out/bin
    runHook postInstall
  '';
}

