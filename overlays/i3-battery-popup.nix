{ inputs, latest-nixpkgs }: final: prev:
let
  i3-battery-popup-pkg = { stdenv }: stdenv.mkDerivation {
    name = "i3-battery-popup";
    src = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/rjekker/i3-battery-popup/d894a102a1ff95019fc59d0a19c89687d502cd1a/i3-battery-popup";
      sha256 = "sha256:19858yaaqapzl6cdrnc0yzmfb86ppja2kx32y3s9xz775xbc24a4";
    };

    unpackPhase = "cp $src i3-battery-popup";
    configurePhase = "patchShebangs i3-battery-popup";
    installPhase = ''install -Dm755 i3-battery-popup "$out"/bin/i3-battery-popup'';
  };
in
{
  i3-battery-popup = prev.callPackage i3-battery-popup-pkg { };
}
