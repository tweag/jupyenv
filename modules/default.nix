{
  self,
  config,
  lib,
  mkJupyterlab,
  mkKernel,
  system,
  ...
}: let
  types = lib.types;
in {
  options = {
    jupyterlab = {
      runtimePackages = lib.mkOption {
        type = types.listOf types.package;
        description = "A list of runtime packages available to all binaries";
        default = [];
      };
    };

    build = lib.mkOption {
      type = types.package;
      internal = true;
    };

    nixpkgs = import ./types/nixpkgs.nix {inherit lib self system;};
  };

  imports = [
    ./../modules/kernels/bash/default.nix
    ./../modules/kernels/c/default.nix
    ./../modules/kernels/elm/default.nix
    ./../modules/kernels/go/default.nix
    ./../modules/kernels/haskell/default.nix
    ./../modules/kernels/javascript/default.nix
    ./../modules/kernels/julia/default.nix
    ./../modules/kernels/nix/default.nix
    ./../modules/kernels/ocaml/default.nix
    ./../modules/kernels/postgres/default.nix
    ./../modules/kernels/python/default.nix
    ./../modules/kernels/r/default.nix
    ./../modules/kernels/rust/default.nix
    ./../modules/kernels/scala/default.nix
    ./../modules/kernels/typescript/default.nix
    ./../modules/kernels/zsh/default.nix
    ./../modules/kernels/sage/default.nix
  ];
  # TODO: add kernels
  #++ map (name: ./. + "/../modules/kernels/${name}/module.nix") (builtins.attrNames (builtins.readDir ./../modules/kernels));

  config = {
    build = mkJupyterlab {
      kernels =
        lib.flatten
        (
          builtins.map
          (
            kernelTypeName:
              builtins.map
              (
                kernelName:
                  config.kernel.${kernelTypeName}.${kernelName}.build
              )
              (builtins.attrNames config.kernel.${kernelTypeName})
          )
          (builtins.attrNames config.kernel)
        );
    };
    _module.args.pkgs = config.nixpkgs;
  };
}
