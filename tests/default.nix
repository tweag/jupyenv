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

        #( xeusCling {
        #    name = "test";
        #})

      ];
    };

  # Made for uploading to cachix:
  # nix-build -A build | cachix push jupyterwith
  build = jupyterlab;

  shell = jupyterlab.env;

  docker = mkDockerImage { inherit jupyterlab; };

in
  { inherit build docker shell; }
