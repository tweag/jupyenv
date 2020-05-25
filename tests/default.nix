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

        # Doesn't build without a nmp install due to zeromq. Needs sandbox off.
        #( iJavascript {
        #   name = "test";
        #})

        ( iPythonWith {
            name = "test";
        })

        ( iRubyWith {
            name = "test";
        })

        # Juniper has been removed from rPackages for some reason.
        #( juniperWith {
        #    name = "test";
        #})

        # Fails on MacOS
        #( iRWith {
        #    name = "test";
        #})

        # This is hard to make work. We will work on it later.
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
