{
  lib,
  stdenv,
  fetchzip,
  buildDartPackage,
}: let
  source = builtins.fromJSON (builtins.readFile ./source.json);
in
  buildDartPackage rec {
    pname = "dart-sass";
    inherit (source) version;

    src = fetchzip {
      inherit (source) url;
      sha256 = source.hash;
    };

    specFile = "${src}/pubspec.yaml";
    lockFile = ./pub2nix.lock;

    meta = with lib; {
      description = "The reference implementation of Sass, written in Dart.";
      homepage = "https://sass-lang.com/dart-sass";
      maintainers = [maintainers.tadfisher maintainers.djacu];
      license = licenses.mit;
    };
  }
