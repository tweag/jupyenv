{
  description = "Your jupyterWith project";

  inputs.nixpkgs.follows = "jupyterWith/nixpkgs";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.jupyterWith.url = "github:tweag/jupyterWith";

  # inputs.jupyterWith.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    jupyterWith,
  }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = builtins.attrValues jupyterWith.overlays;
      };

      kernels = let
        inherit (builtins) map readDir attrNames;
        inherit (pkgs.lib.attrsets) filterAttrs;
        inherit (pkgs.lib.strings) hasPrefix hasSuffix;
      in
        map (name: import ./kernels/${name} {inherit pkgs;})
        (attrNames
          (filterAttrs
            (n: v: v == "regular" && hasSuffix ".nix" n && !hasPrefix "_" n)
            (readDir ./kernels)));

      jupyterEnvironment =
        pkgs.jupyterWith.jupyterlabWith {inherit kernels;};
    in rec {
      defaultPackage = packages.jupyterEnvironment;
      packages = {inherit jupyterEnvironment;};
    });
}
