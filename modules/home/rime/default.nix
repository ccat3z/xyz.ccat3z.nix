{ lib, pkgs, config, ... }:
let
  inherit (lib) filterAttrs hasSuffix nameValuePair mapAttrs';
  inherit (builtins) attrNames readDir map baseNameOf listToAttrs;
  rimeConfigs = listToAttrs (map
    (f: nameValuePair "${f}" ./${f})
    (attrNames (filterAttrs (n: v: hasSuffix ".yaml" n) (readDir ./.))));

  onlineDicts =
    let
      inherit (pkgs) fetchurl;
    in
    mapAttrs' (n: v: nameValuePair "${n}.dict.yaml" v)
      {
        zhwiki = fetchurl {
          url = "https://github.com/felixonmars/fcitx5-pinyin-zhwiki/releases/download/0.2.4/zhwiki-20240210.dict.yaml";
          hash = "sha256-2Y4M4RrBBxNKGyWx+Y+nmFEsKPukfNsaggIyVrWM204=";
        };
      };

  schema.pinyin-simp =
    let
      pkg = pkgs.fetchFromGitHub {
        owner = "rime";
        repo = "rime-pinyin-simp";
        rev = "52b9c75f085479799553f2499c4f4c611d618cdf";
        sha256 = "1zi9yqgijb4r3q5ah89hdwbli5xhlmg19xj8sq1grnpfbw2hbdbj";
      };
    in
    lib.optionals pkgs.hostPlatform.isDarwin {
      "pinyin_simp.dict.yaml" = "${pkg}/pinyin_simp.dict.yaml";
      "pinyin_simp.schema.yaml" = "${pkg}/pinyin_simp.schema.yaml";
    };

  rimeTargetDir = if pkgs.hostPlatform.isDarwin then "Library/Rime" else ".config/ibus/rime";
in
{
  options = {
    programs.rime.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.linuxGraphical.enable;
    };
  };

  config = lib.mkIf config.programs.rime.enable {
    home.file = mapAttrs'
      (n: v: nameValuePair "${rimeTargetDir}/${n}" { source = v; })
      (rimeConfigs // onlineDicts // schema.pinyin-simp)
    ;
  };
}
