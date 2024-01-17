{ pkgs, ... }:
{
  services.proxy = {
    enable = true;
    tproxy = true;
    tproxyPackage = pkgs.tproxy-helper.override {
      useSystemWideTools = true;
    };
  };
}
