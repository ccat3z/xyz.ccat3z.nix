{ stdenv, fetchFromGitHub, gnum4, version ? "545.29.02", ... }:
stdenv.mkDerivation {
  pname = "nvidia-modprobe";
  inherit version;

  buildInputs = [ gnum4 ];

  makeFlags = [ "PREFIX=$(out) " ];

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "nvidia-modprobe";
    rev = version;
    hash = "sha256-1yQpEUt3K3DUWif3SsPukjS4Pl5l/9kaT9eNpkZrXzs=";
  };
}
