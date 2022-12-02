{inputs, latest-nixpkgs}: final: prev:
{
  direnv = latest-nixpkgs.legacyPackages."${prev.system}".direnv;

  nix-direnv = prev.nix-direnv.overrideAttrs (finalAttrs: previousAttrs: {
    version = "2.2.0";

    src = prev.fetchFromGitHub {
      owner = "nix-community";
      repo = "nix-direnv";
      rev = final.nix-direnv.version;
      sha256 = "sha256-htlSwXYmT+baFRhSnEGvNCtcS5qa/VgSXFm5Lavy7eM=";
    };
  });
}
