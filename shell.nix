with (import ./. {});

let
  jupyter =
    jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "hvega";
            packages = p: with p; [ hvega PyF formatting string-qq ];
        })

        ( iPythonWith {
            name = "numpy";
            packages = p: with p; [ numpy ];
        })
      ];

      directory = mkDirectoryWith {
        extensions = [
          "jupyterlab-ihaskell"
          "jupyterlab_bokeh"
          "@jupyterlab/toc"
          "qgrid"
        ];
      };
    };
in
  jupyter.env
