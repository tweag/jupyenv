{ nixpkgsPath ? <nixpkgs> }:
let
  pkgs = import nixpkgsPath {};
  yarn2nix = import ./yarn2nix { inherit nixpkgsPath; };
  nixLib = import ./yarn2nix/nix-lib { lib=pkgs.lib; pkgs=pkgs; yarn2nix=yarn2nix; };
  allDeps = nixLib.callTemplate ./npm-package.nix (nixLib.buildNodeDeps (pkgs.callPackage ./npm-deps.nix {}));
in
  nixLib.buildNodePackage {
    src = nixLib.removePrefixes [ "node_modules" ] ./.;
    key={name=allDeps.name; scope="";};
    version=allDeps.version;
    nodeBuildInputs=allDeps.nodeBuildInputs;
  }
