{ pkgs, fetchzip, gnomeExtensions, ... }:
let
  version = 29;
  sha256 = "sha256-Cz9VnTcZI8VoPAvPNeK3rhvewM9jHP3RfIVx0rcD3iM=";
  inherit (gnomeExtensions) buildShellExtension;
in
(buildShellExtension {
  uuid = "monitor@astraext.github.io";
  pname = "astra-monitor";
  description = "Resource Monitor for GNOME shell";
  link = "https://github.com/AstraExt/astra-monitor";
  name = "";
  inherit version sha256;
  metadata = "";
}).overrideAttrs {
  src = fetchzip {
    url = "https://github.com/AstraExt/astra-monitor/releases/download/v${builtins.toString version}/monitor@astraext.github.io.shell-extension.zip";
    stripRoot = false;
    inherit sha256;
  };

  patches = [ ./negative-order.patch ];
}
