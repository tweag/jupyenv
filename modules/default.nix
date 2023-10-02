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
    ./../modules/kernels/bash
    ./../modules/kernels/c
    ./../modules/kernels/elm
    ./../modules/kernels/go
    ./../modules/kernels/haskell
    ./../modules/kernels/javascript
    ./../modules/kernels/julia
    ./../modules/kernels/nix
    ./../modules/kernels/ocaml
    ./../modules/kernels/postgres
    ./../modules/kernels/python
    ./../modules/kernels/r
    ./../modules/kernels/rust
    ./../modules/kernels/scala
    ./../modules/kernels/typescript
    ./../modules/kernels/zsh
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
