let
  jupyterLibPath = ../../..;
  nixpkgsPath = jupyterLibPath + "/nix";
  jupyter = import jupyterLibPath {};
  pkgs = import nixpkgsPath {};
  dontCheck = pkgs.haskell.lib.dontCheck;

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      #extraIHaskellFlags = "--debug";
      name = "Funflow";
      packages = p: [
        (dontCheck (p.callHackage "funflow" "1.5.0" {}))
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
