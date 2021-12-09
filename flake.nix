{
  description = "declarative and reproducible Jupyter environments - powered by Nix";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    flake-compat = {
      url = github:/teto/flake-compat/support-packages;
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/release-21.11";
    ihaskell.url = github:gibiansky/IHaskell;
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , ihaskell
    , flake-utils
    , ...
    }:
    (flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"]
      (system:
      let
        pkgs = import nixpkgs
          {
            inherit system;
            allowUnsupportedSystem = true;
            overlays = nixpkgs.lib.attrValues self.overlays;
              # [ self.overlays.jupyterWith ];
          };
        ihaskellOverlay = ihaskell.packages.${system}.ihaskell-env.ihaskellOverlay;

      in
      {

        packages = let
          iPython = pkgs.jupyterWith.kernels.iPythonWith {
            name = "Python-data-env";
            ignoreCollisions = true;
          };

          iHaskell = pkgs.jupyterWith.kernels.iHaskellWith {
            name = "ihaskell-flake";
            packages = p: with p; [ vector aeson ];
            extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
            haskellPackages = pkgs.haskellPackages;
          };

        in
        {
          jupyterEnvironment = pkgs.jupyterWith.jupyterlabWith {
              kernels = [ iPython iHaskell ];
              directory = "./.jupyterlab";
            };
        };

        defaultPackage = self.packages."${system}".jupyterEnvironment;

      }
      )
    ) //
    {
      overlays = {
        jupyterWith = final: prev: rec {
          jupyterWith = prev.callPackage ./. { pkgs = final; };

          inherit (jupyterWith)
              jupyterlabWith
              kernels
              mkBuildExtension
              mkDirectoryWith
              mkDirectoryFromLockFile
              mkDockerImage
              ;
        };

        # haskell = import ./nix/haskell-overlay.nix;
        haskell = final: prev: {
          haskellPackages = prev.haskellPackages.override (old: {
            overrides =
              prev.lib.composeExtensions
                (old.overrides or (_: _: {}))
                ihaskell.packages."${prev.system}".ihaskell-env.ihaskellOverlay;
              });
        };

        python = import ./nix/python-overlay.nix;

      };
    };
}
