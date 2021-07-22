{
  description = "declarative and reproducible Jupyter environments - powered by Nix";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    }:
    (flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs = import nixpkgs
          {
            inherit system;
            overlays = [
              self.overlay
              (import ./nix/haskell-overlay.nix)
              (import ./nix/python-overlay.nix)
            ];
          };
      in
      rec {
        defaultPackage = pkgs.jupyterWith;

        lib = {
          inherit (pkgs.jupyterWith)
            jupyterlabWith
            kernels
            mkBuildExtension
            mkDirectoryWith
            mkDirectoryFromLockFile
            mkDockerImage
            ;
        };
      }
      )
    ) //
    {
      overlay = final: prev: { jupyterWith = prev.callPackage ./. { pkgs = final; }; };
    };
}
