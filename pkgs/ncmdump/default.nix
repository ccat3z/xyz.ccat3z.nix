{ stdenv, fetchFromGitHub, cmake, ... }:
let
  version = "1.3.2";
in
stdenv.mkDerivation {
  pname = "ncmdump";
  inherit version;

  src = fetchFromGitHub {
    owner = "taurusxin";
    repo = "ncmdump";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-a0Be25+NJpU6wjNG6499AVdeRqEsaFvt2DT7krJOtwA=";
  };

  nativeBuildInputs = [
    cmake
  ];
}
