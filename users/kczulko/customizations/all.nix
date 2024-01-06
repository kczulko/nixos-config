{ pkgs, ... }:

{
  polybar-launcher = import ./polybar-launcher.nix { inherit pkgs; };
  setup-resolution = import ./setup-resolution.nix { inherit pkgs; };
}
