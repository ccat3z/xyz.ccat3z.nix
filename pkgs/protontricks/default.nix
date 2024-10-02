{ python3Packages
, winetricks
, steam-run
, yad
, ...
}:
let
  inherit (python3Packages) callPackage;
in
callPackage ./protontricks {
  vdf = callPackage ./vdf { };
  inherit winetricks steam-run yad;
}
