with (import ./. {});

(jupyterlabWith {
  kernels = with kernels; [
    # Sample Haskell kernel
    ( iHaskellWith {
        name = "hvega";
        packages = p: with p; [
          hvega
          PyF
          formatting
          string-qq
        ];
      })

    # Sample Python kernel
    ( iPythonWith {
        name = "numpy";
        packages = p: with p; [
          numpy
        ];
      })
  ];

  directory = import ./generate-directory.nix {
    extensions = [
      "jupyterlab-ihaskell"
      "jupyterlab_bokeh"
      "@jupyterlab/toc"
      "qgrid"
    ];
  };
}).env
