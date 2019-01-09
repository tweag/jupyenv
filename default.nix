{ nixpkgsPath ? ./nix }:

let
  pkgs = import nixpkgsPath {};
  python3 = pkgs.python3.pkgs;

  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};
  mkKernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k}");

  # Default JUPYTERLAB_DIR to be distributed statically.
  jupyterlabDir = pkgs.stdenv.mkDerivation {
    name = "jupyterlab-extended";
    phases = "installPhase";
    src = ./jupyterlab;
    installPhase = "cp -r $src $out";
  };

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlab-extended = { directory, kernels }:
    python3.toPythonModule (
      python3.jupyterlab.overridePythonAttrs (oldAttrs: {
        makeWrapperArgs = [
          "--set JUPYTERLAB_DIR ${directory}"
          "--set JUPYTER_PATH ${mkKernelsString kernels}"
        ];
      })
    );

  # Shell that launches JupyterLab with the correct directory
  # and kernel configuration.
  jupyterWith = { directory ? null, kernels }:
    let
      jupyterlab = jupyterlab-extended {
        directory =
          if isNull directory
            then jupyterlabDir
            else directory;
        inherit kernels;
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
  { inherit jupyterWith kernels; }
