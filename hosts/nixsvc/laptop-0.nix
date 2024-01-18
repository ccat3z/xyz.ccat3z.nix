{ pkgs, ... }:
{
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.overlays = [
    (self: super: {
      tproxy-helper = super.tproxy-helper.override {
        useSystemWideTools = true;
      };
    })
  ];

  services.proxy = {
    enable = true;
    tproxy = true;
  };
}
