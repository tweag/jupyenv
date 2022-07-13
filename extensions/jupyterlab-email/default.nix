{pkgs ? import <nixpkgs> {}}: let
  name = "jupyterlab_email";
  version = "301d74bccc03e5ea7501462331bee167bf31b019";

  extension = pkgs.stdenv.mkDerivation {
    name = "${name}-drv";
    src = pkgs.fetchFromGitHub {
      owner = "timkpaine";
      repo = "${name}";
      rev = "${version}";
      sha256 = "sha256-B3/9djWk60CfstY1tIpTXLQOOm0SdCofOgYj604c4oE=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r js/* $out
    '';
  };
in
  pkgs.mkYarnPackage rec {
    inherit name;
    src = "${extension}";

    buildPhase = ''
      yarn build:babel
      # yarn build:lab
    '';
  }
