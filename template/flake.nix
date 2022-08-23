{
  description = "Your jupyterWith project";

  inputs.nixpkgs.follows = "jupyterWith/nixpkgs";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.jupyterWith.url = "github:tweag/jupyterWith";

  outputs = {
    self,
    nixpkgs,
    flake-compat,
    flake-utils,
    jupyterWith,
  }:
  # TODO - Update Linux first and then MacOS when it is working.
    flake-utils.lib.eachSystem ["x86_64-linux"]
    (
      system: let
        inherit (jupyterWith.lib.${system}) readKernelsFromPath;

        pkgs = import nixpkgs {inherit system;};
        jupyterEnvironment = readKernelsFromPath pkgs ./kernels;
      in rec {
        packages = {inherit jupyterEnvironment;};
        packages.default = jupyterEnvironment;
        apps.default.program = "${jupyterEnvironment}/bin/jupyter-lab";
        apps.default.type = "app";
      }
    );
}
