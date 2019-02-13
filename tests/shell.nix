with (import ../. {});
let
  jupyter =
    jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "haskell-sample";
        })

        ( iPythonWith {
            name = "python-sample";
        })

        ( cKernel {
            name = "c-sample";
        })

        ( iRubyWith {
            name = "sample";
        })

        ( ansibleKernel {
            name = "sample";
        })

        ( juniperWith {
            name = "sample";
        })

      ];

    };
in
  jupyter.env
