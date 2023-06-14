{ writeShellScriptBin, openvpn-openssl_legacy }:
writeShellScriptBin "vpn-connect"
  ''
    sudo ${openvpn-openssl_legacy}/bin/openvpn --config /run/agenix/vpn-config
  ''
