{ lib, stdenvNoCC, bash, nftables, makeWrapper, ... }:
stdenvNoCC.mkDerivation {
  name = "tproxy-helper";
  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ bash nftables ];

  installPhase = ''
    mkdir -p $out/bin
    for cmd in $src/tproxy-helper*; do
      cmd_name="$(basename "$cmd")"
      cp "$cmd" "$out/bin/$cmd_name"
      wrapProgram "$out/bin/$cmd_name" \
        --prefix PATH : ${lib.makeBinPath [ nftables ]}:$out/bin
    done
  '';

  meta = {
    mainProgram = "tproxy-helper";
  };
}
