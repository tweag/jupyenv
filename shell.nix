{ nixpkgsPath ? import ./nixpkgs-src.nix }:
let
  pkgs = import nixpkgsPath {
    overlays = [ (import ./overlay.nix) ];
  };

  pythonEnv = pkgs.python36.withPackages (ps: with ps; [ jupyterlab ]);
  kernels = pkgs.callPackage ./kernels {};
  jupyterlabDir = import ./. {};
in
pkgs.mkShell {
  name="jupyterlab-shell";
  buildInputs=[ pythonEnv ];
  paths = [ pythonEnv ];
  shellHook = ''
    export JUPYTERLAB=${pythonEnv}
    export JUPYTER_PATH=${kernels.haskell}:${kernels.python}
    export JUPYTERLAB_DIR=${jupyterlabDir}
    jupyter lab --app-dir=$JUPYTERLAB_DIR
    '';
}
