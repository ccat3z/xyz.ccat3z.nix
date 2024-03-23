{ pkgs, lib, config, ... }:
let
  inherit (lib) mkOption types mkIf;

  src = pkgs.fetchFromGitHub {
    owner = "jergusg";
    repo = "k380-function-keys-conf";
    rev = "c0363e2e825144adc7e7ef1b37e398d90bfb0b81";
    hash = "sha256-Eubm9duEdUk8FBDbiVx2W20xKcmLrRTnrE+PiQxUuRI=";
  };

  package = pkgs.runCommandCC "k380_conf" { } ''
    mkdir $out
    cd $out
    $CC ${src}/k380_conf.c -o k380_conf
    install -m 755 ${src}/fn_on.sh fn_on.sh
  '';
in
{
  options.hardware.logitech-k380 = {
    enable = lib.mkEnableOption (lib.mdDoc "logitech-k380");

    tool = mkOption {
      type = types.package;
      default = package;
    };
  };

  config =
    let
      cfg = config.hardware.logitech-k380;
    in
    mkIf cfg.enable {
      services.udev.extraRules = ''
        ACTION== "add", KERNEL=="hidraw[0-9]*", RUN+="${cfg.tool}/fn_on.sh /dev/%k"
      '';
    };
}
