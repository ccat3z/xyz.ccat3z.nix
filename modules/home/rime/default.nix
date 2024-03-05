{ lib, pkgs, ... }:
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

  rimeTargetDir = ".config/ibus/rime";
in
{
  home.file = mapAttrs'
    (n: v: nameValuePair "${rimeTargetDir}/${n}" { source = v; })
    (rimeConfigs // onlineDicts)
  ;
}
