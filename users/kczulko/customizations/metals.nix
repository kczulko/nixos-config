{pkgs,...}: with pkgs;

let
  metalsVersion = "0.9.4";
  metalsSha256 = "1k07gg13z3kambvvrxsc27781cd5npb2a50ahdbj7x6j6h67k0pg";
  metalsPkg = metals;
  tarball = fetchTarball https://github.com/kczulko/scala-dev-env/tarball/master;
in
  callPackage "${tarball}/metals.nix" {
    inherit metalsPkg metalsVersion metalsSha256;
  }
