{ pkgs ? import <nixpkgs> {
    overlays = [
      (import ./../../nix/python-overlay.nix)
    ];
  }
}:
let

  python = pkgs.poetry2nix.mkPoetryEnv {
    poetrylock = ./my-python-package/poetry.lock;
  };

  pyproject =
    builtins.fromTOML (builtins.readFile ./my-python-package/pyproject.toml);
  depNames = builtins.attrNames pyproject.tool.poetry.dependencies;

  # Jupyter setup
  jupyterLibPath = ../..;
  jupyter = import jupyterLibPath {};

  iPythonWithPackages = jupyter.kernels.iPythonWith {
    name = "local-package";
    python3 = python;
    packages = p:
      let
        # Building the local package using the standard way.
        myPythonPackage = p.buildPythonPackage {
          pname = "my-python-package";
          version = "0.1.0";
          src = ./my-python-package;
        };
        # Getting dependencies using Poetry.
        poetryDeps =
          builtins.map (name: builtins.getAttr name p) depNames;
      in
        [ myPythonPackage ] ++ poetryDeps ;
  };

  jupyterlabWithKernels = jupyter.jupyterlabWith {
    kernels = [ iPythonWithPackages ];
    extraPackages = p: [p.hello];
  };
in
  jupyterlabWithKernels.env
