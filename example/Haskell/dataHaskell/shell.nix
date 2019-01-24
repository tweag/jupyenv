# Doesn't work currently because of a problem of inline-r with ghc-844
# To make this work, this problem has to be fixed, or alternatively we
# have to setup an ghc-822 with the correct ihaskell
let
  jupyterLibPath = ../../..;
  nixpkgsPath = jupyterLibPath + "/nix";
  pkgs = import nixpkgsPath {};
  jupyter = import jupyterLibPath { pkgs=pkgs; };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      name = "dataHaskell";
      packages = p: with p; [
        dh-core
        datasets
        analyze
        Frames
      ];
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
