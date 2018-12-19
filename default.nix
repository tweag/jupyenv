{ nixpkgsPath ? import ./nixpkgs-src.nix }:

let
  pkgs = import nixpkgsPath {};

  yarn2nixPath = pkgs.fetchFromGitHub {
    owner = "Profpatsch";
    repo = "yarn2nix";
    rev = "1ec3635fd28d2180b4c07ab524ada94d8d327d48";
    sha256 = "0hyc04plczvbilcn68hxnqsr5yfiqy29mb8spg8aj1k2grhzkds9";
  };

  yarn2nix = import yarn2nixPath { inherit nixpkgsPath; };

  nixLib = import "${yarn2nixPath}/nix-lib" {
    inherit pkgs yarn2nix;
    inherit (pkgs) lib;
    };

  allDeps =
    nixLib.callTemplate ./npm-package.nix (
      nixLib.buildNodeDeps (
        pkgs.callPackage ./npm-deps.nix {}
      )
    );

in
  nixLib.buildNodePackage {
    src = nixLib.removePrefixes [ "node_modules" ] ./.;
    key = { name = allDeps.name; scope=""; };
    inherit (allDeps) version nodeBuildInputs;
  }
