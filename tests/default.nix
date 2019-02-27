with (import ../. {});
let
  jupyterlab =
    jupyterlabWith {
      kernels = with kernels; [

        ( ansibleKernel {
            name = "test";
        })

        ( cKernelWith {
            name = "test";
        })

        ( gophernotes {
            name = "test";
        })

        ( iHaskellWith {
            name = "test";
        })

        ( iJavascript {
            name = "test";
        })

        ( iPythonWith {
            name = "test";
        })

        ( iRubyWith {
            name = "test";
        })

        ( juniperWith {
            name = "test";
        })

        ( xeusCling {
            name = "test";
        })

      ];
    };

  shell = jupyterlab.env;

  docker = mkDockerImage { inherit jupyterlab; };

in
  { inherit docker shell; }
