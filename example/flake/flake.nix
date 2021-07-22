{
  description = "JupyterWith :: Flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/a5d03577f0161c8a6e713b928ca44d9b3feb2c37";
    jupyterWith = { url = "path:../../."; };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , jupyterWith
    }:
    (flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            self.overlay
            (final: prev: { jupyterWith = jupyterWith.defaultPackage."${final.system}"; })
          ];
          config = {
            allowBroken = true;
            allowUnfree = true;
            allowUnsupportedSystem = true;
          };
        };
      in
      rec {
        devShell = import ./devshell.nix { inherit pkgs; };
      }
      )
    ) // {
      overlay = final: prev: { };
    };
}
