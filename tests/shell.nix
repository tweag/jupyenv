with (import ../. {});
let
  jupyter =
    jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "haskell-sample";
            packages = p: with p; [ vector ];
        })

        ( iPythonWith {
            name = "python-sample";
            packages = p: with p; [ numpy ];
        })
        ( cKernel {
            name = "c-sample";
        })
        ( ansibleKernel {
            name = "sample";
        })

      ];

    };
in
  jupyter.env
