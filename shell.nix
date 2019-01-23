let
  jupyter = import ./. {};

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = with jupyter.kernels; [
        ( iHaskellWith {
            name = "hvega";
            packages = p: with p; [ hvega PyF formatting string-qq ];
        })

        ( iPythonWith {
            name = "numpy";
            packages = p: with p; [ numpy ];
        })
      ];

      directory = jupyter.mkDirectoryWith {
        extensions = [
          "jupyterlab-ihaskell"
          "jupyterlab_bokeh"
          "@jupyterlab/toc"
          "qgrid"
        ];
      };
    };
in
  jupyterlabWithKernels.env
