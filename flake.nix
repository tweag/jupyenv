{
  description = "Declarative and reproducible Jupyter environments - powered by Nix";

  nixConfig.extra-substituters = [
    "https://tweag-jupyter.cachix.org"
  ];
  nixConfig.extra-trusted-public-keys = [
    "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g="
  ];

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.ihaskell.url = "github:ihaskell/ihaskell";
  inputs.ihaskell.inputs.nixpkgs.follows = "nixpkgs";
  inputs.ihaskell.inputs.flake-compat.follows = "flake-compat";
  inputs.ihaskell.inputs.flake-utils.follows = "flake-utils";
  inputs.npmlock2nix.url = "github:nix-community/npmlock2nix";
  inputs.npmlock2nix.flake = false;
  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";
  inputs.poetry2nix.inputs.flake-utils.follows = "flake-utils";
  inputs.poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.flake-utils.follows = "flake-utils";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-compat,
    flake-utils,
    ihaskell,
    npmlock2nix,
    pre-commit-hooks,
    poetry2nix,
    rust-overlay,
  }: let
    inherit (nixpkgs) lib;

    SYSTEMS = [
      flake-utils.lib.system.x86_64-linux
      # TODO - Fix linux first and then get macos working.
      # flake-utils.lib.system.x86_64-darwin
    ];

    /*
    Takes a path to the kernels directory, `kernelsPath`,
    a kernel name, `fileName`,
    and a file type, `fileType`,
    and verifies that a valid kernel directory exists with that name.
    */
    filterValidKernelPaths = kernelsPath: fileName: fileType: let
      defaultFilePath = "${kernelsPath}/${fileName}/default.nix";
    in
      # Example: kernels/mykernel/default.nix
      if
        (fileType == "directory")
        && fileName != "available"
        && !lib.hasPrefix "_" fileName
        && lib.pathExists defaultFilePath
      then {
        name = fileName;
        path = defaultFilePath;
      }
      # Example: kernels/mykernel.nix
      else if
        (fileType == "regular")
        && lib.hasSuffix ".nix" fileName
        && !lib.hasPrefix "_" fileName
      then {
        name = lib.removeSuffix ".nix" fileName;
        path = "${kernelsPath}/${fileName}";
      }
      # return null when path kernel path not valid
      else null;

    /*
    Takes a path to a kernels directory, `kernelsPath`,
    and returns path to nix file of the kernel config

    Example:
      getKernelAttrsetFromPath ./kernels ->
      [
        { name = "postgres"; path = "kernels/postgres/default.nix"; }
        { name = "mypython"; path = "kernels/mypython.nix"; }
        ...
      ]
    */
    getKernelAttrsetFromPath = kernelsPath:
      lib.remove null
      (
        lib.mapAttrsToList
        (filterValidKernelPaths kernelsPath)
        (builtins.readDir kernelsPath)
      );

    /*
    Takes a path to a kernels directory, `kernelsPath`
    and a kernel name, `kernelName`,
    and returns a set of the form:
      { description = "<kernelName> kernel"; path = <PATH> }
    where `PATH` is in the Nix store.
    */
    mkKernelFlakeOutput = name: path: {
      description = "${name} kernel";
      inherit path;
    };

    /*
    List kernels in a path.

    Example:
      mapKernelsFromPath ./kernels ->
        {
          "example_kernel" = ./kernels/example_kernel;
        }
    */
    mapKernelsFromPath = path:
      lib.optionalAttrs
      (lib.pathExists path)
      (
        builtins.listToAttrs
        (
          builtins.map
          (
            {
              name,
              path,
            }: {
              inherit name;
              value = path;
            }
          )
          (getKernelAttrsetFromPath path)
        )
      );

    /*
    Takes a path to the kernels directory, `kernelsPath`,
    reads all files from the kernels directory and returns a set of
    valid kernels that is in a shape of jupyterKernels flake output.

    Example:
      getKernelsFromPath ./kernels ->
        {
          kernels = {
            example_kernel = ./kernels/example;
            ...
          };
          available = {
            bash = ./kernels/example;
            ...
          };
        }
    */
    getKernelsFromPath = kernelsPath: {
      kernels = mapKernelsFromPath kernelsPath;
      available = mapKernelsFromPath "${kernelsPath}/available";
    };

    kernelsConfig = getKernelsFromPath (self + /kernels);

    overlays = [
      poetry2nix.overlay
      rust-overlay.overlays.default
      (self: super: {
        npmlock2nix = self.callPackage npmlock2nix {};
      })
      (self: super: {
        # XXX: Putting that in pkgs is a bit ugly
        ihaskellPkgs = import "${ihaskell}/release.nix";
      })
    ];
    _overlay = lib.composeManyExtensions overlays;
  in
    (flake-utils.lib.eachSystem SYSTEMS (
      system: let
        pkgs = import nixpkgs {
          inherit overlays system;
        };

        pkgs_stable = import nixpkgs-stable {
          inherit overlays system;
        };

        baseArgs = {
          inherit self pkgs;
        };

        pre-commit = pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            alejandra.enable = true;
            typos = {
              enable = true;
              name = "typos";
              description = "Source code spell checker";
              entry = "${pkgs.typos}/bin/typos --write-changes --config _typos.toml";
              types = ["file"];
              files = "\\.((txt)|(md)|(nix)|\\d)$";
            };
          };
          excludes = ["^\\.jupyter/"]; # JUPYTERLAB_DIR
        };

        mkdocs = pkgs.python3.withPackages (p: [
          p.mkdocs
          p.mkdocs-material
          p.mkdocs-material-extensions
        ]);

        docs = pkgs.stdenv.mkDerivation {
          name = "jupyterwith-docs";
          src = self;
          nativeBuildInputs = [mkdocs];
          buildPhase = ''
            mkdocs build --site-dir dist
          '';
          installPhase = ''
            mkdir $out
            cp -R dist/* $out/
          '';
        };

        jupyterlabEnvWrapped = {
          projectDir ? self, # TODO: only include relevant files/folders
          pyproject ? projectDir + "/pyproject.toml",
          poetrylock ? projectDir + "/poetry.lock",
          overrides ? import ./overrides.nix pkgs,
          python ? pkgs.python3,
          editablePackageSources ? {},
          extraPackages ? (ps: []),
          preferWheels ? false,
          # groups ? ["devs"], # TODO: add groups after updating to latest poetry2nix. make sure to inherit below
        }: let
          jupyterlabEnvBase = pkgs.poetry2nix.mkPoetryEnv {
            inherit
              projectDir
              pyproject
              poetrylock
              overrides
              python
              editablePackageSources
              extraPackages
              preferWheels
              ;
          };
          jupyterlab-checker =
            pkgs.writeText "jupyterlab-checker"
            ''
              from jupyterlab.commands import build_check, ensure_app;
              import sys

              ensure_app_return = ensure_app('.jupyter/lab/share/jupyter/lab')
              build_check_return = build_check()
              if ensure_app_return is None and not build_check_return:
                sys.exit(0)
              # print(f'{ensure_app_return = }')
              # print(f'{build_check_return = }')
              sys.exit(1)
            '';
          jupyterlab-cond-build =
            pkgs.writeShellScript "jupyterlab-cond-build"
            ''
              ${jupyterlabEnvBase}/bin/python ${jupyterlab-checker}
              checker=$?
              if [ "$checker" -ne 0 ]
              then
                echo jupyterWith needs to build JupyterLab.
                # we need to build the jupyter lab environment before it can be used
                ${jupyterlabEnvBase}/bin/jupyter lab build
              else
                echo jupyterWith does not need build JupyterLab. Starting...
              fi
            '';
        in
          pkgs.runCommand "chmod-${jupyterlabEnvBase.name}"
          {nativeBuildInputs = [pkgs.makeWrapper];}
          ''
            mkdir -p $out/bin
            for i in ${jupyterlabEnvBase}/bin/*; do
              filename=$(basename $i)

              if [[ "$filename" == jupyter* ]]; then
                cat <<EOF > $out/bin/$filename
            #!${pkgs.runtimeShell} -e
            trap "chmod +w --recursive \$PWD/.jupyter" EXIT
            ${jupyterlab-cond-build}
            ${jupyterlabEnvBase}/bin/$filename "\$@"
            EOF
                chmod +x $out/bin/$filename
              else
                makeWrapper \
                  ${jupyterlabEnvBase}/bin/$filename \
                  $out/bin/$filename
            fi
            done
          '';

        # Creates a derivation with kernel.json and logos
        mkKernel = kernelInstance_: let
          # TODO: we should probably assert that the kernelInstance is correctly shaped.
          #{ name,                    # required; type: string
          #, language,                # required; type: enum or string
          #, argv,                    # required; type: list of strings
          #, displayName ? name       # optional; type: string
          #, codemirrorMode ? "yaml"  # optional; type: enum or string
          #, logo32,                  # optional; type: absolute store path
          #, logo64,                  # optional; type: absolute store path
          #}:
          kernelInstance =
            builtins.removeAttrs kernelInstance_ ["path"];

          kernelLogos = ["logo32" "logo64"];

          kernelJSON =
            lib.mapAttrs'
            (
              name: value:
                if builtins.elem name kernelLogos
                then {
                  inherit name;
                  value = baseNameOf value;
                }
                else if name == "displayName"
                then {
                  name = "display_name";
                  inherit value;
                }
                else if name == "codemirrorMode"
                then {
                  name = "codemirror_mode";
                  inherit value;
                }
                else {inherit name value;}
            )
            kernelInstance;

          copyKernelLogos =
            builtins.concatStringsSep "\n"
            (
              builtins.map
              (
                logo: let
                  kernelLogoPath = kernelInstance.${logo};
                in
                  lib.optionalString (builtins.hasAttr logo kernelInstance) ''
                    cp ${kernelLogoPath} $out/kernels/${kernelInstance.name}/${baseNameOf kernelLogoPath}
                  ''
              )
              kernelLogos
            );
        in
          pkgs.runCommand "${kernelInstance.name}-jupyter-kernel"
          {
            passthru = {
              inherit kernelInstance;
              IS_JUPYTER_KERNEL = true;
            };
          }
          (
            ''
              mkdir -p $out/kernels/${kernelInstance.name}
              echo '${builtins.toJSON kernelJSON}' \
                > $out/kernels/${kernelInstance.name}/kernel.json
            ''
            + copyKernelLogos
          );

        /*
        TODO:
        */

        mkJupyterlab = {
          jupyterlabEnvArgs ? {},
          kernels ? k: [], # k: [ (k.python {}) k.bash ],
          # extensions ? e: [], # e: [ e.jupy-ext ]
          runtimePackages ? [], # runtime package available to all binaries
          flakes ? [], # flakes where to detect custom kernels/extensions
        }: let
          allRuntimePackages =
            runtimePackages
            # nodejs and npm are needed to be able to install extensions
            ++ (with pkgs; [
              nodejs
              nodePackages.npm
            ]);

          /*
          An attribute set of all the available and valid kernels where the
          attribute name is the kernel name and the attribute value is the
          overridable version of the kernel's default.nix file.
          returns:
          {
            <kernelName> = <kernelFactory>;
          }
          */
          availableKernels =
            builtins.listToAttrs
            (
              lib.flatten
              (
                builtins.map
                (
                  flake:
                    if builtins.hasAttr "jupyterKernels" flake
                    then
                      (
                        lib.mapAttrsToList
                        (
                          name: kernel: {
                            inherit name;
                            value = args: {
                              inherit args;
                              inherit (kernel) path;
                            };
                          }
                        )
                        flake.jupyterKernels
                      )
                    else []
                )
                ([self] ++ flakes)
              )
            );

          # user kernels (imported and initialized)
          userKernels =
            builtins.map
            (
              kernelConfig:
                (
                  if builtins.isFunction kernelsConfig
                  then let
                    kernelConfig_ = kernelsConfig {};
                  in
                    import kernelConfig_.path (baseArgs // kernelConfig_.args)
                  else import kernelConfig.path (baseArgs // kernelConfig.args)
                )
                // {inherit (kernelConfig) path;}
            )
            (kernels availableKernels);

          kernelDerivations =
            builtins.map mkKernel userKernels;

          jupyterlabEnv = jupyterlabEnvWrapped jupyterlabEnvArgs;

          # create directories for storing jupyter configs
          jupyterDir = pkgs.runCommand "jupyter-dir" {} ''
            # make jupyter config and data directories
            mkdir -p $out/config $out/data

            # make jupyter lab user settings and workspaces directories
            mkdir -p $out/config/lab/{user-settings,workspaces}
          '';

          /*
          Finds kernels from kernelDerivations that have the same kernel
          instance name and adds them to a list.
          */
          duplicateKernelNames =
            lib.foldl'
            (
              acc: e:
                if
                  let
                    allNames = map (k: k.name) userKernels;
                  in
                    (lib.count (x: x == e.name) allNames) > 1
                then acc ++ [e]
                else acc
            )
            []
            userKernels;
        in
          # If any duplicates are found, throw an error and list them.
          if duplicateKernelNames != []
          then let
            listOfDuplicates =
              map
              (k: "Kernel name ${k.name} in ${k.path}")
              duplicateKernelNames;
          in
            builtins.throw ''
              Kernel names must be unique. Duplicate kernel names found:
              ${lib.concatStringsSep "\n" listOfDuplicates}
            ''
          else
            pkgs.runCommand "wrapper-${jupyterlabEnv.name}"
            {nativeBuildInputs = [pkgs.makeWrapper];}
            ''
              mkdir -p $out/bin
              for i in ${jupyterlabEnv}/bin/*; do
                filename=$(basename $i)
                ln -s ${jupyterlabEnv}/bin/$filename $out/bin/$filename
                wrapProgram $out/bin/$filename \
                  --prefix PATH : ${lib.makeBinPath allRuntimePackages} \
                  --set JUPYTERLAB_DIR .jupyter/lab/share/jupyter/lab \
                  --set JUPYTERLAB_SETTINGS_DIR ".jupyter/lab/user-settings" \
                  --set JUPYTERLAB_WORKSPACES_DIR ".jupyter/lab/workspaces" \
                  --set JUPYTER_PATH ${lib.concatStringsSep ":" kernelDerivations} \
                  --set JUPYTER_CONFIG_DIR "${jupyterDir}/config" \
                  --set JUPYTER_DATA_DIR ".jupyter/data" \
                  --set IPYTHONDIR "/path-not-set" \
                  --set JUPYTER_RUNTIME_DIR ".jupyter/runtime"
              done

              # add Julia for IJulia
              allKernelPaths=${lib.concatStringsSep ":" kernelDerivations}
              if [[ $allKernelPaths = *julia* ]]
              then
                echo 'Adding Julia as an available package.'
                for i in ${pkgs.julia-bin}/bin/*; do
                  filename=$(basename $i)
                  ln -s ${pkgs.julia-bin}/bin/$filename $out/bin/$filename
                done
              fi
            '';

        exampleJupyterlabKernels = (
          builtins.listToAttrs
          (
            builtins.map
            (
              name: {
                name = "jupyterlab-kernel-${pkgs.lib.replaceStrings ["_"] ["-"] name}";
                value = mkJupyterlab {
                  kernels = availableKernels: [
                    (import kernelsConfig.kernels.${name} {
                      inherit name availableKernels;
                      extraArgs = {inherit pkgs pkgs_stable;};
                    })
                  ];
                };
              }
            )
            (builtins.attrNames kernelsConfig.kernels)
          )
        );

        exampleJupyterlabAllKernels = mkJupyterlabFromPath ./kernels {inherit pkgs pkgs_stable;};

        /*
        Returns kernel instance from a folder.

        Example:
          getKernelInstance "python" (self + /kernels) ->
            <kernelInstance>
        */
        getKernelInstance = availableKernels: extraArgs: {
          name,
          path,
        }:
          import path {
            inherit availableKernels name;
            extraArgs = baseArgs // extraArgs;
          };

        /*
        Return jupyterEnvironment with kernels
        Example:
          mkJupyterlabFromPath ./kernels ->
            <jupyterEnvironment>
        */
        mkJupyterlabFromPath = kernelsPath: extraArgs:
          mkJupyterlab {
            kernels = availableKernels:
              builtins.map
              (getKernelInstance availableKernels extraArgs)
              (getKernelAttrsetFromPath kernelsPath);
          };
      in rec {
        lib = {
          inherit
            mkJupyterlab
            mkJupyterlabFromPath
            ;
        };
        packages =
          {
            jupyterlab = jupyterlabEnvWrapped {};
            jupyterlab-all-example-kernels = exampleJupyterlabAllKernels;
            update-poetry-lock =
              pkgs.writeShellApplication
              {
                name = "update-poetry-lock";
                runtimeInputs = [pkgs.python3Packages.poetry];
                text = ''
                  shopt -s globstar
                  for lock in **/poetry.lock; do
                  (
                    echo Updating "$lock"
                    cd "$(dirname "$lock")"
                    poetry update
                  )
                  done
                '';
              };
            inherit mkdocs docs;
            default = jupyterlabEnvWrapped {};
          }
          // exampleJupyterlabKernels;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.typos
            poetry2nix.defaultPackage.${system}
            pkgs.python3Packages.poetry
            pkgs.rnix-lsp
            self.packages."${system}".update-poetry-lock
            mkdocs
          ];
          shellHook = ''
            ${pre-commit.shellHook}
          '';
        };
        checks = {
          inherit pre-commit;
          jupyterlabEnv = jupyterlabEnvWrapped {};
        };
        apps = {
          update-poetry-lock =
            flake-utils.lib.mkApp
            {drv = self.packages."${system}".update-poetry-lock;};
        };
      }
    ))
    // rec {
      jupyterKernels = builtins.mapAttrs mkKernelFlakeOutput kernelsConfig.available;
      templates.default = {
        path = ./template;
        description = "Boilerplate for your jupyterWith project";
        welcomeText = ''
          You have created a jupyterWith template.

          Run `nix run` to immediately try it out.

          See the jupyterWith documentation for more information.

            https://github.com/tweag/jupyterWith/blob/main/docs/how-to.md
            https://github.com/tweag/jupyterWith/blob/main/docs/tutorials.md
        '';
      };
      overlays.default = _overlay;
    };
}
