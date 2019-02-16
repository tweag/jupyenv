let
  jupyterLibPath = ../../..;
  nixpkgsPath = jupyterLibPath + "/nix";

  pkgs = import nixpkgsPath {};
  monadBayesSrc = pkgs.fetchFromGitHub {
    owner = "adscib";
    repo = "monad-bayes";
    rev = "647ba7cb5a98ae028600f3d828828616891b40fb";
    sha256 = "1z4i03idsjnxqds3b5zk52gic2m8zflhh2v64yp11k0idxggiv2d";
  };

  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides = pkgs.lib.composeExtensions old.overrides
        (self: hspkgs: {
          monad-bayes = hspkgs.callCabal2nix "monad-bayes" "${monadBayesSrc}" {};
        });
      });

  jupyter = import jupyterLibPath { pkgs=pkgs; };

  ihaskellWithPackages = jupyter.kernels.iHaskellWith {
      #extraIHaskellFlags = "--debug";
      haskellPackages=haskellPackages;
      name = "bayes-monad";
      packages = p: with p; [
        monad-bayes
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
