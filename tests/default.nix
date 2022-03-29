{pkgs}: let
  custom-ihaskell = import ./custom-ihaskell.nix {inherit pkgs;};
  test-kernel-path = pkgs.callPackage ./test-kernel-path.nix {};

  includedKernels = with pkgs.jupyterWith.kernels;
    [
      (ansibleKernel {
        name = "test";
      })

      (bashKernel {
        name = "test";
      })

      (cKernelWith {
        name = "test";
      })

      (gophernotes {
        name = "test";
      })

      (iHaskellWith {
        name = "test";
      })

      (iJavascript {
        name = "test";
      })

      (iPythonWith {
        name = "test";
      })

      (iNixKernel {
        name = "test";
      })

      (iRubyWith {
        name = "test";
      })

      # Fails on MacOS.
      #( iRWith {
      #    name = "test";
      #})

      # This is hard to make work. We will work on it later.
      (rustWith {
        name = "test";
      })
      # Fails due to https://erratique.ch/software/uutf/releases/uutf1.0.3.tbz not existing
      #(ocamlWith {
      #  name = "test";
      #})
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      (xeusCling {
        name = "test";
      })
      (iJuliaWith {
        name = "test";
      })
    ];

  customIHaskellKernels = with pkgs.jupyterWith.kernels; [
    # One kernel which uses a custom ihaskell + the nixpkgs haskell package set
    (iHaskellWith {
      name = "test";
      customIHaskell = custom-ihaskell.customIHaskell;
    })
    # And another which uses a custom ihaskell + the haskell.nix haskell package set
    (iHaskellWith {
      name = "test";
      customIHaskell = custom-ihaskell.customIHaskell;
      haskellPackages = custom-ihaskell.haskellPackages;
    })
  ];

  jupyterlab = pkgs.jupyterWith.jupyterlabWith {
    kernels = includedKernels;
  };

  jupyterlabCustomIHaskell = pkgs.jupyterWith.jupyterlabWith {
    kernels = customIHaskellKernels;
  };

  # Made for uploading to cachix:
  # nix-build -A build | cachix push jupyterwith
  build = jupyterlab;
  build-custom-ihaskell = jupyterlabCustomIHaskell;

  shell = jupyterlab.env;

  docker = pkgs.jupyterWith.mkDockerImage {inherit jupyterlab;};

  kernel-tests = {
    # Note: joining these to avoid creating so many "result" directories in the working directory
    core = pkgs.symlinkJoin {
      name = "test-kernel-paths-core";
      paths = builtins.map test-kernel-path includedKernels;
    };
    customIHaskell = pkgs.symlinkJoin {
      name = "test-kernel-paths-ihaskell";
      paths = builtins.map test-kernel-path customIHaskellKernels;
    };
  };
in {inherit build build-custom-ihaskell docker shell kernel-tests;}
