{ lib, stdenvNoCC, nftables, iproute2, libcap, makeWrapper, python3, glib, coreutils-full, ... }:
stdenvNoCC.mkDerivation rec {
  name = "tproxy-helper";
  src = ./.;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [
    (python3.withPackages (pythonPackages: with pythonPackages; [
      dbus-python
      pygobject3
      gst-python
    ]))
  ];

  installPhase = ''
    mkdir -p $out/bin
    for cmd in $src/tproxy-helper*; do
      cmd_name="$(basename "$cmd")"
      cp "$cmd" "$out/bin/$cmd_name"

      substituteInPlace $out/bin/$cmd_name \
        --subst-var out \
        --subst-var-by GI_TYPELIB_PATH ${lib.makeSearchPath "lib/girepository-1.0" [ glib.out ]} \
        --subst-var-by PATH ${lib.makeBinPath [ nftables iproute2 libcap coreutils-full ]} \
        --subst-var-by nft ${nftables}/bin/nft
    done

    mkdir -p $out/share/dbus-1/system-services
    cat <<EOF > $out/share/dbus-1/system-services/xyz.ccat3z.TProxyHelper.service
    [D-BUS Service]
    Name=xyz.ccat3z.TProxyHelper
    Exec=$out/bin/tproxy-helper-service.py
    User=root
    SystemdService=tproxy-helper.service
    EOF

    mkdir -p $out/lib/systemd/system
    cat <<EOF > $out/lib/systemd/system/tproxy-helper.service
    [Unit]
    Description=TProxy Helper

    [Service]
    Type=dbus
    BusName=xyz.ccat3z.TProxyHelper
    ExecStart=$out/bin/tproxy-helper-service.py
    Environment=PYTHONUNBUFFERED=1
    EOF

    mkdir -p $out/share/dbus-1/system.d
    cat <<EOF > $out/share/dbus-1/system.d/xyz.ccat3z.TProxyHelper.conf
    <?xml version="1.0" encoding="UTF-8"?>

    <!DOCTYPE busconfig PUBLIC
     "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
     "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
    <busconfig>
      <!-- Only root can own the service -->
      <policy user="root">
        <allow own="xyz.ccat3z.TProxyHelper"/>
      </policy>
    
      <!-- Anyone can send messages to the service -->
      <policy context="default">
        <allow send_destination="xyz.ccat3z.TProxyHelper"/>
      </policy>
    </busconfig>
    EOF
  '';

  meta = {
    mainProgram = "tproxy-helper";
  };
}
