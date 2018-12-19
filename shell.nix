{ nixpkgsPath ? import ./nixpkgs-src.nix }:
let
  pkgs = import nixpkgsPath {};

  jupyter = pkgs.jupyter;
  jupyterlab = pkgs.python36Packages.jupyterlab;
  kernels = pkgs.callPackage ./kernels {};

  jupyterlabDir = import ./. {};

in
pkgs.stdenv.mkDerivation {
  name="jlab";
  buildInputs=[ jupyter jupyterlab ];
  shellHook = ''
    export JUPYTER=${jupyter}
    export JUPYTERLAB=${jupyterlab}
    export JUPYTER_PATH=${kernels.haskell}:${kernels.python}
    export JUPYTERLAB_DIR=${jupyterlabDir}
    jupyter lab
    '';
}
