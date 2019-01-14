{ nixpkgsPath ? ./nix }:

let
  pkgs = import nixpkgsPath {};
  python3 = pkgs.python3.pkgs;
  pythonPath = python3.makePythonPath [
    python3.ipykernel
    python3.jupyter_contrib_core
    python3.jupyter_nbextensions_configurator
    python3.tornado
  ];

  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};
  kernelsDefault = [ (kernels.iPythonWith {}) ];
  mkKernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k}");

  # Default JUPYTERLAB_DIR to be distributed statically.
  jupyterlabDir = pkgs.stdenv.mkDerivation {
    name = "jupyterlab-directory";
    phases = "installPhase";
    src = ./jupyterlab;
    installPhase = "cp -r $src $out";
  };

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlabWith = { directory ? jupyterlabDir, kernels ? kernelsDefault }:
      let
       jupyterlab=python3.toPythonModule (
           python3.jupyterlab.overridePythonAttrs (oldAttrs: {
             makeWrapperArgs = [
               "--set JUPYTERLAB_DIR ${directory}"
               "--set JUPYTER_PATH ${mkKernelsString kernels}"
               "--set PYTHONPATH ${pythonPath}"
             ];
           })
           );
       env=pkgs.mkShell {
             name="jupyterlab-shell";
             buildInputs=[ jupyterlab ];
             shellHook = ''
               export JUPYTERLAB=${jupyterlab}
               jupyter lab
             '';
           };
    in
      jupyterlab.override (oldAttrs: { 
        passthru=oldAttrs.passthru or {} // {inherit env;};
      });
in
  { inherit jupyterlabWith kernels; }
