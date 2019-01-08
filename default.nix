{ nixpkgsPath ? ./nix}:

let
  pkgs = import nixpkgsPath {};
  kernels = pkgs.callPackage ./kernels {};
  jupyterlabDir=pkgs.stdenv.mkDerivation {
    name="jupyterlab-extended";
    phases="installPhase";
    src=./jupyterlab;
    installPhase = ''
      cp -r $src $out
    '';
  };
in

with pkgs.python3.pkgs; toPythonModule (
  jupyterlab.overridePythonAttrs(oldAttrs: {
    makeWrapperArgs = ["--set JUPYTERLAB_DIR ${jupyterlabDir}"
                       "--set JUPYTER_PATH ${kernels.haskell}:${kernels.python}:${kernels.haskell_data}"];
  })
)
