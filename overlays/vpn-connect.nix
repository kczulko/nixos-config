{ inputs, latest-nixpkgs }: final: prev:
{
  vpn-connect = prev.callPackage ../pkgs/openvpn-wrapper.nix { };
}
