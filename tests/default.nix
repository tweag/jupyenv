with (import ../. {});
let
  jupyterlab =
    jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "haskell-sample";
        })

        ( iPythonWith {
            name = "python-sample";
        })

        ( cKernelWith {
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

  shell = jupyterlab.env;

  docker = mkDockerImage { inherit jupyterlab; };

in
  { inherit docker shell; }
