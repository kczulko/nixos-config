{ inputs, latest-nixpkgs }: final: prev:

{
  tkcli = prev.callPackage ../pkgs/tkcli.nix { };
}

