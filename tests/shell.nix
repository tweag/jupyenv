with (import ../. {});
let
  jupyter =
    jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "haskell-sample";
            packages = p: with p; [ ];
        })

        ( iPythonWith {
            name = "python-sample";
            packages = p: with p; [ ];
        })
        ( cKernel {
            name = "c-sample";
        })

        ( iRubyWith {
            name = "sample";
            packages = p: with p; [ ];
        })

        ( ansibleKernel {
            name = "sample";
        })

      ];

    };
in
  jupyter.env
