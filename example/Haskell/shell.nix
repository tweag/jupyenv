let
  system = builtins.currentSystem;
  flake = import ../../default.nix {};
  jupyterWith = flake.packages.${system}.jupyterWith;

  ihaskellWithPackages = jupyterWith.kernels.iHaskellWith {
    name = "Local";
    packages = p: [
      (p.callPackage ./my-haskell-package {})
      p.text
    ];
  };

  jupyterlabWithKernels = jupyterWith.jupyterlabWith {
    kernels = [ihaskellWithPackages];
  };
in
  jupyterlabWithKernels.env
