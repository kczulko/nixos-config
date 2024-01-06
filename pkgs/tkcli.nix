{ buildGoModule, fetchFromGitHub }:
buildGoModule {
  pname = "tkcli";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "tkhq";
    repo = "tkcli";
    rev = "cb0332d8d4c871637579be2228a17bcfa21287ab";
    hash = "sha256-X18xPo5DEdKmqoEJrh0+lEm6CAOyTq0cLyk5j/nWw+Q=";
  };
  vendorHash = "sha256-8Dj6FyCZccJhT7IK5HasB6wKmbn26gPMwMTB3fWfwYQ=";
  sourceRoot = "source/src";
  GOWORK="off";
  doCheck = false;
}
