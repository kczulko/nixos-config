{ trivialBuild, fetchFromGitHub, helm }:
trivialBuild {
  pname = "helm-ag";
  version = "0.0.1";

  packageRequires = [
    helm
  ];

  src = fetchFromGitHub {
    owner = "emacsattic";
    repo = "helm-ag";
    rev = "a7b43d9622ea5dcff3e3e0bb0b7dcc342b272171";
    sha256 = "sha256-bIuZPMsY0iwkUFOfB6rGno0WvlPtbqqgujwhUb6nTLw=";
  };
}
