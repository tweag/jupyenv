{ nixpkgsPath ? ./nix }:

let
  pkgs = import nixpkgsPath {};
  python3 = pkgs.python3.pkgs;
  pythonPath = python3.makePythonPath [
    python3.ipykernel
  ];

  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};
  kernelsDefault = [ (kernels.pythonWith {}) ];
  mkKernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k}");

  # Default JUPYTERLAB_DIR to be distributed statically.
  jupyterlabDir = pkgs.stdenv.mkDerivation {
    name = "jupyterlab-directory";
    phases = "installPhase";
    src = ./jupyter-path;
    installPhase = "cp -r $src $out";
  };

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlabRunner = { directory ? jupyterlabDir , kernels ? kernelsDefault }:
    python3.toPythonModule (
      python3.jupyterlab.overridePythonAttrs (oldAttrs: {
        makeWrapperArgs = [
          "--set JUPYTERLAB_DIR ${directory}"
          "--set JUPYTER_PATH ${mkKernelsString kernels}"
          "--set PYTHONPATH ${pythonPath}"
        ];
      })
    );

  # Shell that launches JupyterLab with the correct directory
  # and kernel configuration.
  jupyterWith = { directory ? jupyterlabDir, kernels ? kernelsDefault }:
    let
      jupyterlab = jupyterlabRunner {
        inherit directory kernels;
      };
    in
      pkgs.mkShell {
        name="jupyterlab-shell";
        buildInputs=[ jupyterlab ];
        shellHook = ''
          export JUPYTERLAB=${jupyterlab}
          jupyter lab
        '';
      };
in
  { inherit jupyterlabRunner jupyterWith kernels;
  }
