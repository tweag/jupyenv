{ nixpkgsPath ? import ./nixpkgs-src.nix }:

let
  pkgs = import nixpkgsPath {};

  yarn2nixPath = pkgs.fetchFromGitHub {
    owner = "Profpatsch";
    repo = "yarn2nix";
    rev = "919012b32c705e57d90409fc2d9e5ba49e05b471";
    sha256 = "1f9gw31j7jvv6b2fk5h76qd9b78zsc9ac9hj23ws119zzxh6nbyd";
  };

  yarn2nix = import yarn2nixPath { inherit nixpkgsPath; };

  nixLib = import "${yarn2nixPath}/nix-lib" {
    inherit pkgs yarn2nix;
    inherit (pkgs) lib;
    };

  allDeps =
    nixLib.callTemplate ./out/staging/npm-package.nix (
      nixLib.buildNodeDeps (
        pkgs.callPackage ./out/staging/npm-deps.nix {}
      )
    );

  jupyterTmp = nixLib.buildNodePackage {
    src = nixLib.removePrefixes [ "node_modules" ] ./out/staging;
    key = { name = allDeps.name; scope=""; };
    inherit (allDeps) version nodeBuildInputs;
  };

in
  pkgs.stdenv.mkDerivation {
    name = "jupyterlab-dir";
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/static
      cp -r ${pkgs.python36Packages.jupyterlab}/share/jupyter/lab/* $out
      rm -r $out/static
      cp -r ${jupyterTmp}/build $out/static
    '';
  }
