{pkgs,...}:

{
  metals = import ./metals.nix { inherit pkgs; };
}
