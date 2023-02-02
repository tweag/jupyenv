{
  self,
  config,
  lib,
  system,
  mkJupyterlab,
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
      features = lib.mkOption {
        type = types.listOf types.str;
        description = "A list of features to enable";
        default = [];
        example = ["lsp"];
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
            // (lib.recursiveUpdate (import ./types/poetry.nix {
                inherit lib self;
                config = config.jupyterlab.jupyterlabEnvArgs;
              })
              {
                projectDir.default = self.outPath;
              });
        };
        default = {};
        description = "Arguments for the jupyterlab poetry's environment";
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
    ./../kernels/available/bash/module.nix
    ./../kernels/available/c/module.nix
    ./../kernels/available/elm/module.nix
    ./../kernels/available/go/module.nix
    ./../kernels/available/haskell/module.nix
    ./../kernels/available/javascript/module.nix
    ./../kernels/available/julia/module.nix
    ./../kernels/available/nix/module.nix
    ./../kernels/available/ocaml/module.nix
    ./../kernels/available/postgres/module.nix
    ./../kernels/available/python/module.nix
    ./../kernels/available/r/module.nix
    ./../kernels/available/rust/module.nix
    ./../kernels/available/scala/module.nix
    ./../kernels/available/typescript/module.nix
    ./../kernels/available/zsh/module.nix
  ];
  # TODO: add kernels
  #++ map (name: ./. + "/../kernels/available/${name}/module.nix") (builtins.attrNames (builtins.readDir ./../kernels/available));

  config = {
    build = mkJupyterlab {
      jupyterlabEnvArgs = {
        inherit
          (config.jupyterlab.jupyterlabEnvArgs)
          pyproject
          projectDir
          editablePackageSources
          preferWheels
          poetrylock
          poetry2nix
          ;

        extraPackages = let
          findFeature = name:
            if config.jupyterlab.features != []
            then
              (
                if name == (lib.head (lib.intersectLists [name] config.jupyterlab.features))
                then true
                else false
              )
            else false;

          enabledLanguage = lang: feature:
            (
              if config.kernel.${lang} != {}
              then true
              else false
            )
            && (findFeature feature);
        in
          ps:
            (lib.optionals (enabledLanguage "python" "lsp") [
              ps.jupyter-lsp
              ps.python-lsp-server
            ])
            ++ (lib.optionals (findFeature "jupytext") [ps.jupytext])
            ++ (config.jupyterlab.jupyterlabEnvArgs.extraPackages ps);
      };

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
      runtimePackages = config.jupyterlab.runtimePackages;
      #flakes = config.flakes;
    };
  };
}
