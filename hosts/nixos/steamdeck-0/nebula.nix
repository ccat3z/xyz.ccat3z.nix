{ pkgs, ... }:
let
  nft = "${pkgs.nftables}/bin/nft";
  ctl = pkgs.writeScript "nebula-nft" ''
    #! ${pkgs.bash}/bin/bash

    set -e

    usage () {
        echo "$0 up|down"
    }

    case "$1" in
        up|down) action=do_$1 ;;
        *) usage; exit 1 ;;
    esac

    do_up() {
        ${nft} -f- <<EOF
    table ip nebula
    delete table ip nebula
    table ip nebula {
      chain postrouting {
        type nat hook postrouting priority srcnat; policy accept;
        ip saddr 10.55.12.0/24 ip daddr 10.55.3.0/24 masquerade
        }
    }
    EOF
    }

    do_down() {
        ${nft} -f- <<EOF
    table ip nebula
    delete table ip nebula
    EOF
    }

    "$action"
  '';
in
{
  sops.secrets."nebula.yaml" = {
    sopsFile = ./nebula.yaml.enc;
    format = "binary";
    mode = "0444";
    restartUnits = [ "nebula.service" ];
  };
  systemd.services.nebula = {
    serviceConfig = {
      ExecStartPre = "${ctl} up";
      ExecStopPost = "${ctl} down";
    };
  };
}
