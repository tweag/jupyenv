{pkgs}:
with pkgs; let
  iPython = jupyterWith.kernels.iPythonWith {
    name = "Python-data-env";
    ignoreCollisions = true;
  };

  iHaskell = jupyterWith.kernels.iHaskellWith {
    extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
    name = "ihaskell-flake";
  };

  iJulia = let
    currentDir = builtins.getEnv "PWD";
  in
    jupyterWith.kernels.iJuliaWith rec {
      name = "Julia-data-env";
      activateDir = currentDir;
      JULIA_DEPOT_PATH = activateDir + "./.julia_depot";
      extraEnv = {};
    };

  jupyterEnvironment =
    jupyterWith.jupyterlabWith {
      kernels = [iPython iHaskell iJulia];
      directory = "./.jupyterlab";
    };
in
  pkgs.mkShell rec {
    buildInputs = [
      jupyterEnvironment
      iJulia.runtimePackages
    ];

    JULIA_DEPOT_PATH = "./.julia_depot";

    shellHook = ''
    '';
  }
