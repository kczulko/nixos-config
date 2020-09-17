{pkgs}:

pkgs.citrix_workspace.overrideAttrs ( oldAttrs: rec {
  citrix-tarball = builtins.fetchTarball {
    url = "http://downloads.citrix.com/17780/linuxx64-20.04.0.21.tar.gz?__gda__=1599823765_27e61d62cb8780e9c29fd98840cc5e4e";
    sha256 = "E923592216F9541173846F932784E6C062CB09C9E8858219C7489607BF82A0FB";
  };

  buildInputs = [ citrix-tarball ] ++ oldAttrs.buildInputs;
})
