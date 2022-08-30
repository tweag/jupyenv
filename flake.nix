{
  description = "Declarative and reproducible Jupyter environments - powered by Nix";

  nixConfig.extra-substituters = "https://tweag-jupyter.cachix.org";
  nixConfig.extra-trusted-public-keys = "tweag-jupyter.cachix.org-1:UtNH4Zs6hVUFpFBTLaA4ejYavPo5EFFqgd7G7FxGW9g=";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-22.05";
  inputs.flake-compat.url = "github:edolstra/flake-compat";
  inputs.flake-compat.flake = false;
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  inputs.pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
  inputs.pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
  inputs.poetry2nix.url = "github:nix-community/poetry2nix";
  inputs.poetry2nix.inputs.flake-utils.follows = "flake-utils";
  inputs.poetry2nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.flake-utils.follows = "flake-utils";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  #inputs.ihaskell.url = "github:gibiansky/IHaskell";
  #inputs.ihaskell.inputs.nixpkgs.follows = "nixpkgs";
  #inputs.ihaskell.inputs.flake-compat.follows = "flake-compat";
  #inputs.ihaskell.inputs.flake-utils.follows = "flake-utils";

  # TODO: For some reason I can not override anything in hls
  #inputs.ihaskell.inputs.hls.inputs.flake-compat.follows = "flake-compat";
  #inputs.ihaskell.inputs.hls.inputs.flake-utils.follows = "flake-utils";
  #inputs.ihaskell.inputs.hls.inputs.nixpkgs.follows = "nixpkgs";
  #inputs.ihaskell.inputs.hls.inputs.pre-commit-hooks.follows = "pre-commit-hooks";

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-compat,
    flake-utils,
    pre-commit-hooks,
    poetry2nix,
    rust-overlay,
    #ihaskell,
  }: let
    inherit (nixpkgs) lib;

    SYSTEMS = [
      flake-utils.lib.system.x86_64-linux
      # TODO - Fix linux first and then get macos working.
      # flake-utils.lib.system.x86_64-darwin
    ];

    /*
    Takes a path to the kernels directory, `kernelsPath`,
    and a kernel name, `kernelName`,
    and returns a path to the kernel's default.nix file.
    */
    getKernelPath = kernelsPath: kernelName:
      builtins.path {
        name = "jupyterlab-${kernelName}-kernel-source";
        path = kernelsPath + "/${kernelName}";
      };

    getKernelDefaultFile = kernelsPath: kernelName: "${getKernelPath kernelsPath kernelName}/default.nix";

    /*
    Takes a path to the kernels directory, `kernelsPath`,
    a kernel name, `kernelName`,
    and a file type, `fileType`,
    and verifies that a valid kernel directory exists with that name.
    */
    filterValidKernelPaths = kernelsPath: kernelName: fileType:
      (fileType == "directory")
      && lib.pathExists (getKernelDefaultFile kernelsPath kernelName);

    /*
    Takes a path to the kernels directory, `kernelsPath`,
    reads all files from the kernels directory and returns a set of
    valid kernels.
    */
    getKernelsFromPath = kernelsPath: let
      paths =
        lib.filterAttrs
        (filterValidKernelPaths kernelsPath)
        (builtins.readDir kernelsPath);
    in
      lib.optionalAttrs
      (lib.pathExists kernelsPath)
      (
        builtins.listToAttrs
        (
          builtins.map
          (
            kernelName: {
              name = kernelName;
              value = {
                description = "${kernelName} kernel";
                path = getKernelPath kernelsPath kernelName;
              };
            }
          )
          (builtins.attrNames paths)
        )
      );
  in
    (flake-utils.lib.eachSystem SYSTEMS (
      system: let
        overlays = [
          poetry2nix.overlay
          rust-overlay.overlays.default
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
          };
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
            if builtins.isFunction kernelInstance_
            then kernelInstance_ {}
            else kernelInstance_;

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
        Takes a package set from nixpkgs, `pkgs`,
        a path to the kernels directory, `kernelsPath`,
        and a kernel name, `kernelName`,
        and returns an overridable version of a kernel's default.nix file.
        */
        makeKernelOverridable = kernelPath:
          lib.makeOverridable
          (import "${kernelPath}/default.nix")
          {inherit self pkgs;};

        mkJupyterlabInstance = {
          kernels ? k: [], # k: [ (k.python {}) k.bash ],
          # extensions ? e: [], # e: [ e.jupy-ext ]
          flakes ? [], # flakes where to detect custom kernels/extensions
        }: let
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
                          kernelName: kernel: {
                            name = kernelName;
                            value = makeKernelOverridable kernel.path;
                          }
                        )
                        flake.jupyterKernels
                      )
                    else []
                )
                ([self] ++ flakes)
              )
            );

          kernelDerivations = builtins.map mkKernel (kernels availableKernels);

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
                --set JUPYTERLAB_DIR ${jupyterlab}/share/jupyter/lab \
                --set JUPYTERLAB_SETTINGS_DIR ".jupyter/lab/user-settings" \
                --set JUPYTERLAB_WORKSPACES_DIR ".jupyter/lab/workspaces" \
                --set JUPYTER_PATH ${lib.concatStringsSep ":" kernelDerivations} \
                --set JUPYTER_CONFIG_DIR "${jupyterDir}/config" \
                --set JUPYTER_DATA_DIR ".jupyter/data" \
                --set IPYTHONDIR "/path-not-set" \
                --set JUPYTER_RUNTIME_DIR "/path-not-set"
            done
          '';

        kernels = {
          ansible = {
            displayName = "Example Ansible Kernel";
          };
          rust = {
            displayName = "Example Rust Kernel";
          };
          nix = {
            displayName = "Example Nix Kernel";
          };
          bash = {
            displayName = "Example Bash Kernel";
          };
          c = {
            displayName = "Example C Kernel";
          };
          ipython = {
            displayName = "Example IPython Kernel";
          };
          ruby = {
            displayName = "Example Ruby Kernel";
          };
          r = {
            displayName = "Example R Kernel";
          };
          javascript = {
            displayName = "Example Javascript Kernel";
          };
          ihaskell = {
            displayName = "Example iHaskell Kernel";
          };
          go = {
            displayName = "Example Go Kernel";
          };
          julia = {
            displayName = "Example Julia Kernel";
          };
          cpp = {
            displayName = "Example C++ Kernel";
          };
          ocaml = {
            displayName = "Example OCaml Kernel";
          };
          elm = {
            displayName = "Example Elm Kernel";
          };
          postgres = {
            displayName = "Example PostgreSQL Kernel";
          };
        };

        jupyterlab_kernels =
          (
            builtins.listToAttrs
            (
              builtins.map
              (
                kernelName: {
                  name = "jupyterlab_kernel_${kernelName}";
                  value = mkJupyterlabInstance {
                    kernels = k: [
                      (k.${kernelName} (kernels.${kernelName} // {name = "example_${kernelName}";}))
                    ];
                  };
                }
              )
              (builtins.attrNames kernels)
            )
          )
          // {
            jupyterlab_kernel_stable_ansible = mkJupyterlabInstance {
              kernels = k: let
                stable_ansible = k.ansible.override {pkgs = pkgs_stable;};
              in [
                (stable_ansible {
                  name = "example_stable_ansible";
                  displayName = "Example (nixpkgs stable) Ansible Kernel";
                })
              ];
            };
          };

        jupyterlab-all-kernels = mkJupyterlabInstance {
          kernels = k:
            builtins.map
            (
              kernelName:
                k.${kernelName} (kernels.${kernelName} // {name = "example_${kernelName}";})
            )
            (builtins.attrNames kernels);
        };

        /*
        Takes a file name, `name` and a file type, `value`, and returns a
        boolean if the file is meant to be an available kernel. Kernels whose
        file names are prefixed with an underscore are meant to be hidden.
        Useful for filtering the output of `readDir`.
        */
        filterAvailableKernels = name: value: let
          inherit (pkgs.lib.strings) hasPrefix hasSuffix;
        in
          (value == "regular")
          && hasSuffix ".nix" name
          && !hasPrefix "_" name;

        /*
        Takes a path to a kernels directory, `path`, and returns the available
        kernels. Name is the kernel name and value is the file type.
        */
        getAvailableKernels = path: let
          inherit (builtins) readDir;
          inherit (pkgs.lib.attrsets) filterAttrs;
        in
          filterAttrs
          filterAvailableKernels
          (readDir path);

        /*
        Takes an attribute set with
          a set from nixpkgs, `pkgs`,
          and a path to a kernels directory, `path`,
        and returns a function that takes
          a set of kernels, `kernels`,
          and a kernel name, `name`,
        and imports it from the kernels directory.
        Returns the imported kernels as the value of an attribute set.
        */
        importKernel = {
          pkgs,
          path,
        }: kernels: name: let
          inherit (pkgs.lib) removeSuffix;
        in {
          name = removeSuffix ".nix" name;
          value = import "${path}/${name}" {inherit pkgs name mkKernel kernels;};
        };

        /*
        Takes a set from nixpkgs, `pkgs`,
        and a path to a kernels directory, `path`,
        and returns a derivation for a JupyterLab environment.
        */
        mkJupyterEnvFromKernelPath = pkgs: path: let
          inherit (builtins) listToAttrs map attrNames;
          importKernelByName = importKernel {inherit pkgs path;};
          kernelNames = attrNames (getAvailableKernels path);
        in
          mkJupyterlabInstance {
            kernels = kernels:
              listToAttrs (
                map (importKernelByName kernels) kernelNames
              );
          };
      in rec {
        lib = {inherit mkJupyterlabInstance mkJupyterEnvFromKernelPath getKernelsFromPath;};
        packages =
          {
            default = jupyterlab;
            inherit jupyterlab jupyterlab-all-kernels;
          }
          // jupyterlab_kernels;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            poetry2nix.defaultPackage.${system}
            pkgs.python3Packages.poetry
          ];
          shellHook = ''
            ${pre-commit.shellHook}
          '';
        };
        checks = {
          inherit pre-commit jupyterlab;
        };
      }
    ))
    // {
      # Example of jupyterKernels flake output
      #jupyterKernels = {
      #  example_kernel = {
      #    description = "Example kernel";
      #    path = ./kernels/example;
      #  };
      #};
      jupyterKernels = getKernelsFromPath (self + /kernels);

      templates.default = {
        path = ./template;
        description = "Boilerplate for your jupyter-nix project";
        welcomeText = builtins.readFile ./template/README.md;
      };
    };
}
