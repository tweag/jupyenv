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
    flake-utils,
    jupyterWith,
  }:
  # TODO - Update Linux first and then MacOS when it is working.
    flake-utils.lib.eachSystem ["x86_64-linux"] (system: let
      inherit (jupyterWith.lib.${system}) mkKernel mkJupyterlabInstance;

      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          self.overlays.default
          jupyterWith.overlays
        ];
      };

      kernels = let
        inherit (builtins) map readDir attrNames;
        inherit (pkgs.lib.attrsets) filterAttrs;
        inherit (pkgs.lib.strings) hasPrefix hasSuffix;

        /*
        Takes a file name, `name` and a file type, `value`, and returns a
        boolean if the file is meant to be an available kernel. Kernels whose
        file names are prefixed with an underscore are meant to be hidden.
        Useful for filtering the output of `readDir`.
        */
        filterAvailableKernels = name: value:
          (value == "regular")
          && hasSuffix ".nix" name
          && !hasPrefix "_" name;

        /*
        Gets the available kernels as a set from the kernels directory. Name is
        the kernel name and value is the file type.
        */
        getAvailableKernels =
          filterAttrs
          filterAvailableKernels
          (readDir ./kernels);

        /*
        Takes a kernel name, `name`, and imports it from the kernels directory.
        */
        importKernel = name:
          import ./kernels/${name} {inherit pkgs;};
      in
        map importKernel (attrNames getAvailableKernels);

      jupyterEnvironment =
        pkgs.jupyterWith.jupyterlabWith {inherit kernels;};
    in rec {
      defaultPackage = packages.jupyterEnvironment;
      packages = {inherit jupyterEnvironment;};
    })
    // {
      overlays.default = final: prev: {};
    };
}
