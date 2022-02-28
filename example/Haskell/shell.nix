let
  jupyter = import ../../nix {};

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
    name = "Local";
    packages = p: [
      (p.callPackage ./my-haskell-package {})
      p.text
    ];
  };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ihaskellWithPackages];
    };
in
  jupyterlabWithKernels.env
