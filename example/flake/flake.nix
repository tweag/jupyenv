{
  description = "JupyterWith :: Flakes Template";

  nixConfig.extra-substituters = "https://jupyterwith.cachix.org";
  nixConfig.extra-trusted-public-keys = "jupyterwith.cachix.org-1:/kDy2B6YEhXGJuNguG1qyqIodMyO4w8KwWH4/vAc7CI=";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/a5d03577f0161c8a6e713b928ca44d9b3feb2c37";
    jupyterWith.url = github:tweag/jupyterWith;
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-utils,
    jupyterWith,
  }:
    (
      flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"]
      (
        system: let
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              jupyterWith.overlays.jupyterWith
              jupyterWith.overlays.python
              jupyterWith.overlays.haskell
              self.overlay
            ];
            config = {
              allowBroken = true;
              allowUnfree = true;
              allowUnsupportedSystem = true;
            };
          };

          iPython = pkgs.jupyterWith.kernels.iPythonWith {
            name = "Python-data-env";
            ignoreCollisions = true;
          };

          iHaskell = pkgs.jupyterWith.kernels.iHaskellWith {
            extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
            name = "ihaskell-flake";
          };
        in {
          packages = {
            inherit iPython iHaskell;

            jupyterEnvironment = pkgs.jupyterWith.jupyterlabWith {
              kernels = [iPython iHaskell];
              directory = "./.jupyterlab";
            };
          };

          defaultPackage = self.packages.${system}.jupyterEnvironment;
        }
      )
    )
    // {
      overlay = final: prev: {};
    };
}
