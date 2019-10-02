let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {
    overlays = [ (import ./overlay.nix) ];
  };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      name = "Frames";
      packages = p: with p; [
        diagrams
        ihaskell-diagrams
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
