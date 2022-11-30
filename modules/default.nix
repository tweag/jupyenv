{
  config,
  lib,
  mkJupyterlab,
  ...
}: let
  types = lib.types;
in {
  options = {
    # jupyterlabEnvArgs ? {},
    # kernels ? k: [], # k: [ (k.python {}) k.bash ],
    # # extensions ? e: [], # e: [ e.jupy-ext ]

    runtimePackages = lib.mkOption {
      type = types.listOf types.package;
      description = "A list of runtime packages available to all binaries";
      default = [];
    };

    # flakes ? [], # flakes where to detect custom kernels/extensions

    build = lib.mkOption {
      type = types.package;
      internal = true;
    };
  };

  imports = [
    ./../kernels/available/python/module.nix
  ];
  # TODO: add kernels
  #++ map (name: ./. + "/../kernels/available/${name}/module.nix") (builtins.attrNames (builtins.readDir ./../kernels/available));

  config = {
    build = mkJupyterlab {
      #jupyterlabEnvArgs = config.jupyterlabEnvArgs;
      kernels = availableKernels:
        lib.flatten
        (
          builtins.map
          (
            kernelTypeName:
              builtins.map
              (
                kernelName:
                  availableKernels.${kernelTypeName}
                  config.kernel.${kernelTypeName}.${kernelName}.kernelArgs
              )
              (builtins.attrNames config.kernel.${kernelTypeName})
          )
          (builtins.attrNames config.kernel)
        );
      runtimePackages = config.runtimePackages;
      #flakes = config.flakes;
    };
  };
}
