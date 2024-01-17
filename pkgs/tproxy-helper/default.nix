{ lib, stdenvNoCC, bash, nftables, iproute2, libcap, makeWrapper, useSystemWideTools ? false, ... }:
stdenvNoCC.mkDerivation rec {
  name = "tproxy-helper";
  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash nftables iproute2 libcap ];

  installPhase = ''
    mkdir -p $out/bin
    for cmd in $src/tproxy-helper*; do
      cmd_name="$(basename "$cmd")"
      cp "$cmd" "$out/bin/$cmd_name"
      ${ if useSystemWideTools then "" else ''
        wrapProgram "$out/bin/$cmd_name" \
          --prefix PATH : ${lib.makeBinPath buildInputs}:$out/bin
      '' }
    done
  '';

  meta = {
    mainProgram = "tproxy-helper";
  };
}
