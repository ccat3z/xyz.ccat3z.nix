{ pkgs, fetchzip, gnomeExtensions, ... }:
let
  version = 12;
  sha256 = "sMibsNSSZBjtfZqPnI+kF4cpRSvNZk4ni9qALS82/mU=";
  inherit (gnomeExtensions) buildShellExtension;
in
(buildShellExtension {
  uuid = "monitor@astraext.github.io";
  pname = "astra-monitor";
  description = "Resource Monitor for GNOME shell";
  link = "https://github.com/AstraExt/astra-monitor";
  version = 12;
  name = "";
  inherit sha256;
  metadata = "";
}).overrideAttrs {
  src = fetchzip {
    url = "https://github.com/AstraExt/astra-monitor/releases/download/v${builtins.toString version}/monitor@astraext.github.io.shell-extension.zip";
    stripRoot = false;
    inherit sha256;
  };

  patches = [ ./negative-order.patch ];
}
