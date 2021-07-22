{
  description = "JupyterWith :: Flakes";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/release-21.05";
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
