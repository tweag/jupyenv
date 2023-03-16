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
    # jupyterlabEnvArgs ? {},
    # kernels ? k: [], # k: [ (k.python {}) k.bash ],
    # # extensions ? e: [], # e: [ e.jupy-ext ]

    jupyterlab = {
      runtimePackages = lib.mkOption {
        type = types.listOf types.package;
        description = "A list of runtime packages available to all binaries";
        default = [];
      };
    };

    # flakes ? [], # flakes where to detect custom kernels/extensions

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
    #    ./../modules/kernels/rust/module.nix
    #    ./../modules/kernels/scala/module.nix
    #    ./../modules/kernels/typescript/module.nix
    ./../modules/kernels/zsh/default.nix
  ];
  # TODO: add kernels
  #++ map (name: ./. + "/../modules/kernels/${name}/module.nix") (builtins.attrNames (builtins.readDir ./../modules/kernels));

  config = {
    build = mkJupyterlab {
      #jupyterlabEnvArgs = config.jupyterlabEnvArgs;
      #runtimePackages = config.jupyterlab.runtimePackages;
      #flakes = config.flakes;
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
