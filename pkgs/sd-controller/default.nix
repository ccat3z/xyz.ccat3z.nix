{ stdenv, fetchFromGitHub, hidapi, udev, cmake, ... }:
stdenv.mkDerivation {
  name = "sd-controller";

  buildInputs = [ hidapi udev ];

  nativeBuildInputs = [ cmake ];

  src = ./src;
}
