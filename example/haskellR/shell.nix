# Doesn't work currently because of a problem of inline-r with ghc-844
# To make this work, this problem has to be fixed, or alternatively we
# have to setup an ghc-822 with the correct ihaskell
let
  pkgs = import ../../nix {};

  jupyter = import ../.. { pkgs=pkgs; };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      name = "haskellR";
      packages = p: with p; [ inline-r ihaskell-inline-r ];
      };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ ihaskellWithPackages ];
      directory = jupyter.mkDirectoryWith {
        extensions = [
          "jupyterlab-ihaskell"
        ];
      };
    };
in
  jupyterlabWithKernels.env
