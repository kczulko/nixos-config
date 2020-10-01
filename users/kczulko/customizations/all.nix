{pkgs,...}:

{
  metals = import ./metals.nix { inherit pkgs; };
  polybar-launcher = import ./polybar-launcher.nix { inherit pkgs; };
}
