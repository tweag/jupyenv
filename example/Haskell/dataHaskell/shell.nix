let
  jupyterLibPath = ../../..;
  nixpkgsPath = jupyterLibPath + "/nix";
  pkgs = import nixpkgsPath {};
  jupyter = import jupyterLibPath {
    overlays = [ (import ./overlay.nix) ];
  };

  dataHaskellCoreSrc = pkgs.fetchFromGitHub {
    owner = "DataHaskell";
    repo = "dh-core";
    rev = "3fd4d8d62e12452745dc484459d1a5874f523df9";
    sha256 = "12z0jfhwpvk5gd1wckasy346aqm0280pv5h7jl1grpk797zjdswx";
  };

  hspkgs = pkgs.haskellPackages;
  dh-core = hspkgs.callCabal2nix "dh-core" "${dataHaskellCoreSrc}/dh-core" {};
  analyze = hspkgs.callCabal2nix "analyze" "${dataHaskellCoreSrc}/analyze" {};

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      name = "dataHaskell";
      packages = p: with p; [
        dh-core
        datasets
        analyze
        Frames
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
