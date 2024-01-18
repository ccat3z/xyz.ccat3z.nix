{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  services.proxy = {
    enable = true;
    tproxy = true;
    tproxyPackage = pkgs.tproxy-helper.override {
      useSystemWideTools = true;
    };
  };
}
