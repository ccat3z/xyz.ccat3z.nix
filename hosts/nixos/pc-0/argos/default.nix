{ pkgs, ... }:
let
  argos-top = (pkgs.runCommand "argos-top" { buildInputs = [ pkgs.python3 ]; }
    ''
      mkdir -p "$out/bin"
      install -m 755 "${./argos-top}" "$out/bin/argos-top"
      patchShebangs --host "$out/bin"
    '');
in
{
  environment.systemPackages = [ argos-top ];
  home.module.programs.argos.scripts."top.5s.py" = "${argos-top}/bin/argos-top";
}
