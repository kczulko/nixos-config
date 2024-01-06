{ inputs, latest-nixpkgs }: final: prev:
let
  unstable = latest-nixpkgs.legacyPackages."${prev.system}";
in
{
  metals_1_0 = unstable.metals.overrideAttrs (final: prev:
    {
      version = "1.0.0";
      deps = unstable.stdenv.mkDerivation {
        name = "${prev.pname}-deps-${final.version}";
        buildCommand = ''
          export COURSIER_CACHE=$(pwd)
          ${unstable.coursier}/bin/cs fetch org.scalameta:metals_2.13:${final.version} \
           -r bintray:scalacenter/releases \
           -r sonatype:snapshots > deps
          mkdir -p $out/share/java
          cp -n $(< deps) $out/share/java/
        '';
        outputHashMode = "recursive";
        outputHashAlgo = "sha256";
        outputHash = "sha256-futBxdMEJN0UdDvlk5FLUUmcG7r7P7D81IhbC2oYn5s=";
      };
      buildInputs = [ final.deps ];
    }
  );
}
