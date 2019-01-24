let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {};

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      name = "cities-wordcloud";
      packages = p: with p; [ hvega PyF formatting string-qq ];
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
