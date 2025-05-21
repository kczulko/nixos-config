{ inputs, latest-nixpkgs }: final: prev:
{
  clipboard-cli = prev.callPackage ./../pkgs/clipboard-cli.nix {};
}
