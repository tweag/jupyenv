{
  description = "declarative and reproducible Jupyter environments - powered by Nix";

  nixConfig.extra-substituters = "https://jupyterwith.cachix.org";
  nixConfig.extra-trusted-public-keys = "jupyterwith.cachix.org-1:/kDy2B6YEhXGJuNguG1qyqIodMyO4w8KwWH4/vAc7CI=";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
  inputs.ihaskell.url = "github:gibiansky/IHaskell";

  outputs =
    { self
    , flake-utils
    , nixpkgs
    , ihaskell
    }:
    let
       SYSTEMS =
         [ "x86_64-linux"
           "x86_64-darwin"
         ];
       overlays =
         { jupyterWith = import ./nix/overlay.nix;
           haskell = (import ./nix/haskell-overlay.nix) ihaskell;
           python = import ./nix/python-overlay.nix;
         };
    in
    (flake-utils.lib.eachSystem SYSTEMS (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            overlays.jupyterWith
            overlays.haskell
            overlays.python
          ];
        };
        pythonKernel = pkgs.jupyterWith.kernels.iPythonWith {
          name = "ipython-kernel";
          ignoreCollisions = true;
        };
        haskellKernel = pkgs.jupyterWith.kernels.iHaskellWith {
          name = "ihaskell-kernel";
          packages = p: with p; [ vector aeson ];
          extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
          haskellPackages = pkgs.haskellPackages;
        };
      in rec {
        packages = {
          jupyterEnvironment = pkgs.jupyterWith.jupyterlabWith {
            kernels = [ pythonKernel haskellKernel ];
          };
          tests = import ./tests { inherit pkgs; };
        };
        defaultPackage = packages.jupyterEnvironment;
      }
    )) // { inherit overlays; };
}
