{ pkgs }:
with pkgs;
let
  iPython = jupyterWith.kernels.iPythonWith {
    name = "Python-data-env";
    ignoreCollisions = true;
  };


  iHaskell = jupyterWith.kernels.iHaskellWith {
    extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
    name = "ihaskell-flake";
  };

  jupyterEnvironment =
    jupyterWith.jupyterlabWith {
      kernels = [ iPython iHaskell ];
      directory = "./.jupyterlab";
    };
in
pkgs.mkShell rec {
  buildInputs = [
    jupyterEnvironment
  ];

  shellHook = ''
  '';
}
