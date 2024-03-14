{ inputs, latest-nixpkgs }: final: prev:
{
  m4a2mp3 = prev.callPackage ../pkgs/m4a2mp3.nix {};
}

