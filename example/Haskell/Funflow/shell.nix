let
  jupyterLibPath = ../../..;
  nixpkgsPath = jupyterLibPath + "/nix";
  pkgs = import nixpkgsPath {};
  jupyter = import jupyterLibPath { pkgs=pkgs; };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      #extraIHaskellFlags = "--debug";
      name = "Funflow";
      packages = p: with p; [
        funflow
      ];
    };

  jupyterlabWithKernels =
    jupyter.jupyterlabWith {
      kernels = [ ihaskellWithPackages ];
      directory = jupyter.mkDirectoryWith {
        extensions = [
          "jupyterlab-ihaskell"
        ];
      };
    };
in
  jupyterlabWithKernels.env
