{ overlays ? []
, config ? {}
, pkgs ? import ./nix { inherit config overlays; }
, python3 ? pkgs.python3
}:

with (import ./lib/directory.nix { inherit pkgs; });
with (import ./lib/docker.nix { inherit pkgs; });

let
  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};
  kernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k.spec}");

  # Default configuration.
  defaultDirectory = "$out/share/jupyter/lab";
  defaultKernels = [ (kernels.iPythonWith {}) ];
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
      # PYTHONPATH setup for JupyterLab
      pythonPath = python3.pkgs.makePythonPath [
        python3.pkgs.ipykernel
        python3.pkgs.jupyter_contrib_core
        python3.pkgs.jupyter_nbextensions_configurator
        python3.pkgs.tornado
      ];
      # NodeJS is required for extensions
      extraPath = pkgs.lib.makeBinPath ([ pkgs.nodejs ] ++ extraPackages pkgs);

      # JupyterLab executable wrapped with suitable environment variables.
      jupyterlab = python3.pkgs.toPythonModule (
        python3.pkgs.jupyterlab.overridePythonAttrs (oldAttrs: {
          makeWrapperArgs = oldAttrs.makeWrapperArgs or [] ++ [
            "--set JUPYTERLAB_DIR ${directory}"
            "--set JUPYTER_PATH ${extraJupyterPath pkgs}:${kernelsString kernels}"
            "--set PYTHONPATH ${extraJupyterPath pkgs}:${pythonPath}"
            "--prefix PATH : ${extraPath}"
          ];
        })
      );

      # Shell with the appropriate JupyterLab, launching it at startup.
      env = pkgs.mkShell {
        name = "jupyterlab-shell";
        inputsFrom = extraInputsFrom pkgs;
        buildInputs =
          [ jupyterlab generateDirectory generateLockFile pkgs.nodejs ] ++
          (map (k: k.runtimePackages) kernels) ++
          (extraPackages pkgs);
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
  { inherit
      jupyterlabWith
      kernels
      mkBuildExtension
      mkDirectoryWith
      mkDirectoryFromLockFile
      mkDockerImage;
    nixpkgs = pkgs;
  }
