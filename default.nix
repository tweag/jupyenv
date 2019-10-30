{ overlays ? []
, pkgs ? import ./nix { inherit overlays; }
}:

with (import ./lib/directory.nix { inherit pkgs; });
with (import ./lib/docker.nix { inherit pkgs; });

let
  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};
  kernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k.spec}");

  # Python version setup.
  python3 = pkgs.python3Packages;

  # Default configuration.
  defaultDirectory = "${python3.jupyterlab}/share/jupyter/lab";
  defaultKernels = [ (kernels.iPythonWith {}) ];

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlabWith = { directory ? defaultDirectory, kernels ? defaultKernels }:
    let
      # PYTHONPATH setup for JupyterLab
      pythonPath = python3.makePythonPath [
        python3.ipykernel
        python3.jupyter_contrib_core
        python3.jupyter_nbextensions_configurator
        python3.tornado
      ];

      # JupyterLab executable wrapped with suitable environment variables.
      jupyterlab = python3.toPythonModule (
        python3.jupyterlab.overridePythonAttrs (oldAttrs: {
          makeWrapperArgs = [
            "--set JUPYTERLAB_DIR ${directory}"
            "--set JUPYTER_PATH ${kernelsString kernels}"
            "--set PYTHONPATH ${pythonPath}"
          ];
        })
      );

      # Shell with the appropriate JupyterLab, launching it at startup.
      env = pkgs.mkShell {
        name = "jupyterlab-shell";
        buildInputs =
          [ jupyterlab generateDirectory pkgs.nodejs pkgs.pandoc pkgs.texlive.combined.scheme-full ] ++ (map (k: k.runtimePackages) kernels);
        shellHook = ''
          export JUPYTER_PATH=${kernelsString kernels}
          export JUPYTERLAB=${jupyterlab}
        '';
      };
    in
      jupyterlab.override (oldAttrs: {
        passthru = oldAttrs.passthru or {} // { inherit env; };
      });
in
  { inherit jupyterlabWith kernels mkDirectoryWith mkDockerImage; }
