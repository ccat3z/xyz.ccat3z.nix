{ pkgs, ... }:
{
#   environment.systemPackages = with pkgs; [ spice-gtk ];
  security.wrappers.spice-client-glib-usb-acl-helper = {
    source = "${pkgs.spice-gtk}/bin/spice-client-glib-usb-acl-helper";
    owner = "root";
    group = "root";
  };
}