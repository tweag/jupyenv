{
  pkgs,
  nodejs ? pkgs."nodejs-16_x",
}: let
  # inherit
  #   (pkgs)
  #   stdenv
  #   lib
  #   callPackage
  #   fetchFromGitHub
  #   fetchurl
  #   nixosTests
  #   ;
  # since = version: lib.versionAtLeast nodejs.version version;
  # before = version: lib.versionOlder nodejs.version version;
in
  final: prev: {
    tslab = prev.tslab.override (oldAttrs: {
      preRebuild = ''
        export NPM_CONFIG_ZMQ_EXTERNAL=true
      '';
      buildInputs = oldAttrs.buildInputs ++ [final.node-gyp-build pkgs.zeromq];
    });
  }
