{
  description = "Your jupyterWith project";

  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;

  inputs.nixpkgs.follows = "jupyterWith/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.jupyterWith.url = "github:tweag/jupyterWith";
  inputs.nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    jupyterWith,
    ...
  } @ inputs:
    flake-utils.lib.eachSystem ["x86_64-linux" "x86_64-darwin"] (system: let
      inherit (jupyterWith.lib.${system}) mkKernel mkJupyterlabInstance;
      pkgs_stable = inputs.nixpkgs-stable.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          jupyterWith.overlays.julia
        ];
      };

      jupyterEnvironment = let
        inherit (builtins) map readDir attrNames;
        inherit (pkgs.lib.attrsets) filterAttrs;
        inherit (pkgs.lib.strings) hasPrefix hasSuffix;
        __inputs__ = inputs // {inherit mkKernel pkgs pkgs_stable;};
      in
        mkJupyterlabInstance {
          kernels = kernels:
            builtins.listToAttrs (map (name: {
                name = pkgs.lib.removeSuffix ".nix" name;
                value = import ./kernels/${name} (__inputs__ // {inherit name kernels;});
              }) (attrNames
                (filterAttrs
                  (n: v: v == "regular" && hasSuffix ".nix" n && !hasPrefix "_" n)
                  (readDir ./kernels))));
        };
    in rec {
      packages = {
        inherit jupyterEnvironment;
        default = jupyterEnvironment;
      };
      devShells.default = pkgs.mkShell {
        buildInputs = [jupyterEnvironment];
      };
    })
    // {
      overlays.default = final: prev: {};
    };
}
