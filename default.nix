{ overlays ? []
, config ? {}
, pkgs ? import ./nix { inherit config overlays; }
}:

with (import ./lib/directory.nix { inherit pkgs; });
with (import ./lib/docker.nix { inherit pkgs; });

let
  # Kernel generators.
  kernelsAvailable = pkgs.callPackage ./kernels {};
  kernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k.spec}");

  # Python version setup.
  python3 = pkgs.python3Packages;

  # Default configuration.
  defaultDirectory = "$out/share/jupyter/lab";
  defaultKernels = [ (kernelsAvailable.iPythonWith {}) ];
  defaultExtraPackages = p: [];
  defaultExtraInputsFrom = p: [];

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlabWith = {
    directory ? defaultDirectory,
    kernels ? defaultKernels,
    extraPackages ? defaultExtraPackages,
    extraInputsFrom ? defaultExtraInputsFrom,
    extraJupyterPath ? _: ""
    }:
    let
      myPython = pkgs.python3.override {
        packageOverrides = final: prev: {
          jupyter = prev.jupyter.overridePythonAttrs (oldAttrs: {
            inherit makeWrapperArgs;
          });
          jupyterlab = prev.jupyterlab.overridePythonAttrs (oldAttrs: {
            inherit makeWrapperArgs;
          });
          notebook = prev.notebook.overridePythonAttrs (oldAttrs: {
            inherit makeWrapperArgs;
          });
          jupyter_console = prev.jupyter_console.overridePythonAttrs (oldAttrs: {
            inherit makeWrapperArgs;
          });
        };
      };

      makeWrapperArgs = [
        "--set JUPYTERLAB_DIR ${directory}"
        "--set JUPYTER_PATH ${extraJupyterPath pkgs}:${kernelsString kernels}"
        "--set PYTHONPATH ${extraJupyterPath pkgs}:${pythonPath}"
        "--prefix PATH : ${extraPath}"
      ];

      # PYTHONPATH setup for JupyterLab
      pythonPath = myPython.pkgs.makePythonPath [
        python3.ipykernel
        python3.jupyter_contrib_core
        python3.jupyter_nbextensions_configurator
        python3.tornado
      ];
      # NodeJS is required for extensions
      extraPath = pkgs.lib.makeBinPath ([ pkgs.nodejs ] ++ extraPackages pkgs);

      # Shell with the appropriate JupyterLab, launching it at startup.
      env = pkgs.mkShell {
        name = "jupyterlab-shell";
        inputsFrom = extraInputsFrom pkgs;
        buildInputs =
          [ myPython.pkgs.jupyterlab generateDirectory generateLockFile pkgs.nodejs ] ++
          (map (k: k.runtimePackages) kernels) ++
          (extraPackages pkgs);
        shellHook = ''
          export JUPYTER_PATH=${kernelsString kernels}
          export JUPYTERLAB=${myPython.pkgs.jupyterlab}
        '';
      };
    in
      myPython.pkgs.jupyterlab.override (oldAttrs: {
        passthru = oldAttrs.passthru or {} // { inherit env; };
      });
in
  { inherit
      jupyterlabWith
      mkBuildExtension
      mkDirectoryWith
      mkDirectoryFromLockFile
      mkDockerImage;

    kernels = kernelsAvailable;
    nixpkgs = pkgs;
  }
