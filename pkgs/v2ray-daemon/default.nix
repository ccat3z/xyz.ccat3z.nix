{ lib
, stdenvNoCC
, bash
, v2ray
, coreutils
, util-linux
, sops
, lsof
, libcap
, ...
}:
stdenvNoCC.mkDerivation rec {
  name = "v2ray-daemon";

  buildInputs = [
    v2ray
    coreutils
    util-linux
    sops
    lsof
    libcap
  ];
  src = ./.;

  dontUnpack = true;
  installPhase =
    let
      binPath = lib.makeBinPath buildInputs;
    in
    ''
      mkdir -p "$out/bin"
      cp "${../../secrets/v2ray.yaml.enc}" "$out"/v2ray.yaml.enc
      substitute "$src/v2ray-daemon" "$out/bin/v2ray-daemon" \
        --subst-var-by path "${binPath}" \
        --subst-var-by sops_enc_v2ray_config "$out/v2ray.yaml.enc"
      chmod +x "$out/bin/v2ray-daemon"
    '';

  mainProgram = "v2ray-daemon";
}
