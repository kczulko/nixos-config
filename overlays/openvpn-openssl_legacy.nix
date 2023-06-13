{inputs, latest-nixpkgs}: final: prev:
{
  openvpn-openssl_legacy = prev.openvpn.override { openssl = prev.openssl_legacy; };
}
