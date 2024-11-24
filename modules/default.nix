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
  nixpkgs-poetry = config.nixpkgs.appendOverlays [
    self.inputs.poetry2nix.overlays.default
  ];
in {
  options = {
    jupyterlab = {
      runtimePackages = lib.mkOption {
        type = types.listOf types.package;
        description = "A list of runtime packages available to all binaries";
        default = [];
      };

      notebookConfig = lib.mkOption {
        type = types.attrs;
        description = "jupyter notebook config which will be written to jupyter_notebook_config.py";
        default = {};
        apply = c: lib.recursiveUpdate (lib.importJSON ./conf/jupyter_notebook_config.json) c;
      };

      jupyterlabEnvArgs = lib.mkOption {
        type = types.submodule {
          options =
            {
              extraPackages = lib.mkOption {
                type = types.functionTo (types.listOf types.package);
                default = ps: [];
                example = ps: [ps.jupytext];
                description = lib.mdDoc "A list of packages for extending the jupyterlab environment";
              };
            }
            // (
              lib.recursiveUpdate (import ./types/poetry.nix {
                inherit lib self;
                config =
                  config.jupyterlab.jupyterlabEnvArgs
                  // {
                    nixpkgs = nixpkgs-poetry;
                  };
              })
              {
                projectDir.default = self.outPath;
                withDefaultOverrides.default = false;
                overrides.default = import (self.outPath + "/lib/overrides.nix") nixpkgs-poetry;
              }
            );
        };
        default = {};
        description = "Arguments for the jupyterlab poetry's environment";
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
    ./../modules/kernels/dotnet
    ./../modules/kernels/sage
  ];
  # TODO: add kernels
  #++ map (name: ./. + "/../modules/kernels/${name}/module.nix") (builtins.attrNames (builtins.readDir ./../modules/kernels));

  config = {
    build = mkJupyterlab {
      jupyterlabEnvArgs = {
        pkgs = nixpkgs-poetry;
        inherit
          (config.jupyterlab.jupyterlabEnvArgs)
          env
          ;
      };
      inherit
        (config.jupyterlab)
        runtimePackages
        notebookConfig
        ;
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
