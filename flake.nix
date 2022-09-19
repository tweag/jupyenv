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
    mkKernelFlakeOutput = {
      name,
      path,
    }: {
      inherit name;
      value = {
        description = "${name} kernel";
        inherit path;
      };
    };

    /*
    Takes a path to the kernels directory, `kernelsPath`,
    reads all files from the kernels directory and returns a set of
    valid kernels that is in a shape of jupyterKernels flake output.

    Example:
      getAvailableKernelsFromPath ./kernels ->
        {
          example_kernel = {
            description = "Example kernel";
            path = ./kernels/example;
          };
        }
    */
    getAvailableKernelsFromPath = kernelsPath:
      lib.optionalAttrs
      (lib.pathExists kernelsPath)
      (
        builtins.listToAttrs
        (
          builtins.map
          mkKernelFlakeOutput
          (getKernelAttrsetFromPath kernelsPath)
        )
      );

    /*
    List available kernels
    */
    jupyterKernels = getAvailableKernelsFromPath (self + /kernels/available);
  in
    (flake-utils.lib.eachSystem SYSTEMS (
      system: let
        overlays = [
          poetry2nix.overlay
          rust-overlay.overlays.default
          (self: super: {
            npmlock2nix = pkgs.callPackage npmlock2nix {};
          })
        ];

        pkgs = import nixpkgs {
          inherit overlays system;
        };

        pkgs_stable = import nixpkgs-stable {
          inherit overlays system;
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
            mdformat = {
              enable = true;
              name = "mdformat";
              description = "An opinionated Markdown formatter";
              entry = "mdformat .";
              types = ["file" "text" "markdown"];
            };
          };
          excludes = ["^\\.jupyter/"]; # JUPYTERLAB_DIR
        };

        jupyterlab = pkgs.poetry2nix.mkPoetryEnv {
          python = pkgs.python3;
          projectDir = self; # TODO: only include relevant files/folders
          overrides = pkgs.poetry2nix.overrides.withDefaults (import ./overrides.nix);
        };

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
            builtins.removeAttrs
            kernelInstance_
            ["override" "overrideDerivation"];

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
        Takes a path to a kernel's directory, `kernelsPath`,
        and returns an overridable version of a kernel's default.nix file.
        */
        makeKernelOverridable = kernelsPath:
          lib.makeOverridable
          (import kernelsPath)
          {inherit self pkgs;};

        mkJupyterlabInstance = {
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
                          kernelName: kernel:
                            lib.nameValuePair
                            kernelName
                            (makeKernelOverridable kernel.path)
                        )
                        flake.jupyterKernels
                      )
                    else []
                )
                ([self] ++ flakes)
              )
            );

          kernelDerivations =
            builtins.map mkKernel (kernels availableKernels);

          # create directories for storing jupyter configs
          jupyterDir = pkgs.runCommand "jupyter-dir" {} ''
            # make jupyter config and data directories
            mkdir -p $out/config $out/data

            # make jupyter lab user settings and workspaces directories
            mkdir -p $out/config/lab/{user-settings,workspaces}
          '';
        in
          pkgs.runCommand "wrapper-${jupyterlab.name}"
          {nativeBuildInputs = [pkgs.makeWrapper];}
          ''
            mkdir -p $out/bin
            for i in ${jupyterlab}/bin/*; do
              filename=$(basename $i)
              ln -s ${jupyterlab}/bin/$filename $out/bin/$filename
              wrapProgram $out/bin/$filename \
                --prefix PATH : ${lib.makeBinPath allRuntimePackages} \
                --set JUPYTERLAB_DIR .jupyter/lab/share/jupyter/lab \
                --set JUPYTERLAB_SETTINGS_DIR ".jupyter/lab/user-settings" \
                --set JUPYTERLAB_WORKSPACES_DIR ".jupyter/lab/workspaces" \
                --set JUPYTER_PATH ${lib.concatStringsSep ":" kernelDerivations} \
                --set JUPYTER_CONFIG_DIR "${jupyterDir}/config" \
                --set JUPYTER_DATA_DIR ".jupyter/data" \
                --set IPYTHONDIR "/path-not-set" \
                --set JUPYTER_RUNTIME_DIR "/path-not-set"
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

        exampleKernelConfigurations = {
          bash = {displayName = "Example Bash Kernel";};
          c = {displayName = "Example C Kernel";};
          elm = {displayName = "Example Elm Kernel";};
          go = {displayName = "Example Go Kernel";};
          haskell = {displayName = "Example Haskell Kernel";};
          python = {displayName = "Example Python Kernel";};
          javascript = {displayName = "Example Javascript Kernel";};
          julia = {displayName = "Example Julia Kernel";};
          nix = {displayName = "Example Nix Kernel";};
          postgres = {displayName = "Example PostgreSQL Kernel";};
          r = {displayName = "Example R Kernel";};
          rust = {displayName = "Example Rust Kernel";};
          typescript = {displayName = "Example Typescript Kernel";};
        };

        exampleJupyterlabKernels =
          (
            builtins.listToAttrs
            (
              builtins.map
              (
                kernelName: {
                  name = "jupyterlab-kernel-${kernelName}";
                  value = mkJupyterlabInstance {
                    kernels = k: [
                      (k.${kernelName}.override (
                        exampleKernelConfigurations.${kernelName}
                        // {name = "example_${kernelName}";}
                      ))
                    ];
                  };
                }
              )
              (builtins.attrNames exampleKernelConfigurations)
            )
          )
          // {
            jupyterlab-kernel-stable-python = mkJupyterlabInstance {
              kernels = k: let
                stable_python = k.python.override {pkgs = pkgs_stable;};
              in [
                (stable_python.override {
                  name = "example_stable_python";
                  displayName = "Example (nixpkgs stable) Python Kernel";
                })
              ];
            };
          };

        exampleJupyterlabAllKernels = mkJupyterlabInstance {
          kernels = k:
            builtins.map
            (
              kernelName:
                k.${kernelName}.override (
                  exampleKernelConfigurations.${kernelName}
                  // {name = "example_${kernelName}";}
                )
            )
            (builtins.attrNames exampleKernelConfigurations);
        };

        /*
        Returns kernel instance from a folder.

        Example:
          getKernelInstance "python" (self + /kernels) ->
            <kernelInstance>
        */
        getKernelInstance = availableKernels: {
          name,
          path,
        }:
          import path {
            inherit availableKernels pkgs;
            kernelName = name;
          };

        /*
        Return jupyterEnvironment with kernels
        Example:
          mkJupyterlabEnvironmentFromPath ./kernels ->
            <jupyterEnvironment>
        */
        mkJupyterlabEnvironmentFromPath = kernelsPath:
          mkJupyterlabInstance {
            kernels = availableKernels:
              builtins.map
              (getKernelInstance availableKernels)
              (getKernelAttrsetFromPath kernelsPath);
          };
      in rec {
        lib = {
          inherit
            mkJupyterlabInstance
            mkJupyterlabEnvironmentFromPath
            getAvailableKernelsFromPath
            ;
        };
        packages =
          {
            inherit jupyterlab;
            jupyterlab-all-kernels = exampleJupyterlabAllKernels;
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
            default = jupyterlab;
          }
          // exampleJupyterlabKernels;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.typos
            jupyterlab
            poetry2nix.defaultPackage.${system}
            pkgs.python3Packages.poetry
            self.packages."${system}".update-poetry-lock
          ];
          shellHook = ''
            ${pre-commit.shellHook}
          '';
        };
        checks = {
          inherit pre-commit jupyterlab;
        };
        apps = {
          update-poetry-lock =
            flake-utils.lib.mkApp
            {drv = self.packages."${system}".update-poetry-lock;};
        };
      }
    ))
    // rec {
      inherit jupyterKernels;
      templates.default = {
        path = ./template;
        description = "Boilerplate for your jupyterWith project";
        welcomeText = ''
          You have created a jupyterWith template that will help you manage
          your JupyterLab project. Run `nix run` to immediately try out the
          environment. See the README for instructions on extending kernels.
        '';
      };
    };
}
