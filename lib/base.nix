{ pkgs }:

{ directory, kernels, extraPackages
}:

with (pkgs.callPackage ./directory.nix {});

let

  # Python version setup.
  python3 = pkgs.python3Packages;

  # Kernels string for environment variable.
  kernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k.spec}");

  # PYTHONPATH setup for JupyterLab.
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

  # Path variable for the environment.
  path =
    [ jupyterlab generateDirectory pkgs.nodejs ] ++
    (map (k: k.runtimePackages) kernels) ++
    (extraPackages pkgs);

  # Environment variables for the Nix shell.
  environment = {
      JUPYTER_PATH = kernelsString kernels;
      JUPYTERLAB = jupyterlab;
  };

  # Shell with the appropriate JupyterLab, launching it at startup.
  env = pkgs.mkShell {
    name = "jupyterlab-shell";
    buildInputs = path;
    shellHook = pkgs.lib.concatStringsSep "\n"
      (pkgs.lib.mapAttrsToList (n: v: "export ${n}=${v}") environment);
  };
in

{
  jupyterlab = jupyterlab.override (oldAttrs: {
    passthru = oldAttrs.passthru or {} // { inherit env; };
  });
  path = path;
  environment = environment;
}
