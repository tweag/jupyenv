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

        ( iRubyWith {
            name = "test";
            packages = p: with p; [ ];
        })

        ( juniperWith {
            name = "test";
            packages = p: with p; [ ggplot2 ];
        })

        ( cKernelWith {
            name = "test";
        })

        ( ansibleKernel {
            name = "test";
        })

        ( xeusCling {
            name = "test";
        })

        ( iJavascript {
            name = "test";
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
