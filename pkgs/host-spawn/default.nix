{ buildGoModule, fetchFromGitHub, lib, ... }:
buildGoModule rec {
  pname = "host-spawn";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "1player";
    repo = "host-spawn";
    rev = "v${version}";
    hash = "sha256-GXTzLONH8v/AutIve16Y/hmxLIP5X1YvLGipryFCA/k=";
  };

  vendorHash = "sha256-Agc3hl+VDTNW7cnh/0g4G8BgzNAX11hKASYQKieBN4M=";

  meta = {
    description = "Run commands on your host from inside your toolbox or flatpak sandbox";
    homepage = "https://github.com/1player/host-spawn";
    license = lib.licenses.mit;
  };
}
