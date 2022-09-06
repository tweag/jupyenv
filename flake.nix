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

    kernels = {
      ansible = {displayName = "Example Ansible Kernel";};
      bash = {displayName = "Example Bash Kernel";};
      c = {displayName = "Example C Kernel";};
      cpp = {displayName = "Example C++ Kernel";};
      elm = {displayName = "Example Elm Kernel";};
      go = {displayName = "Example Go Kernel";};
      haskell = {displayName = "Example Haskell Kernel";};
      python = {displayName = "Example Python Kernel";};
      javascript = {displayName = "Example Javascript Kernel";};
      julia = {displayName = "Example Julia Kernel";};
      nix = {displayName = "Example Nix Kernel";};
      ocaml = {displayName = "Example OCaml Kernel";};
      postgres = {displayName = "Example PostgreSQL Kernel";};
      r = {displayName = "Example R Kernel";};
      ruby = {displayName = "Example Ruby Kernel";};
      rust = {displayName = "Example Rust Kernel";};
      typescript = {displayName = "Example Typescript Kernel";};
    };

    /*
    Takes a path to the kernels directory, `kernelsPath`,
    a kernel name, `kernelName`,
    and a file type, `fileType`,
    and verifies that a valid kernel directory exists with that name.
    */
    filterValidKernelPaths = kernelsPath: fileName: fileType: let
      defaultFilePath = "${kernelsPath}/${fileName}/default.nix";
    in
      # Example: kernels/mykernel/default.nix
      if fileType == "directory" && lib.pathExists defaultFilePath
      then {
        name = fileName;
        path = defaultFilePath;
      }
      # Example: kernels/mykernel.nix
      else if fileType == "regular" && lib.hasSuffix ".nix" fileName
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
      getKernelConfigurationsFromPath ./kernels ->
      [
        { name = "ansible"; path = "kernels/ansible/default.nix"; }
        { name = "mypython"; path = "kernels/mypython.nix"; }
        ...
      ]
    */
    getKernelConfigurationsFromPath = kernelsPath:
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
      getKernelsFromPath ./kernels ->
        {
          example_kernel = {
            description = "Example kernel";
            path = ./kernels/example;
          };
        }
    */
    getKernelsFromPath = kernelsPath:
      lib.optionalAttrs
      (lib.pathExists kernelsPath)
      (
        builtins.listToAttrs
        (
          builtins.map
          mkKernelFlakeOutput
          (getKernelConfigurationsFromPath kernelsPath)
        )
      );
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
        Takes a path to a kernel's directory, `kernelPath`,
        and returns an overridable version of a kernel's default.nix file.
        */
        makeKernelOverridable = kernelPath:
          lib.makeOverridable
          (import kernelPath)
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
          '';

        jupyterlab_kernels =
          (
            builtins.listToAttrs
            (
              builtins.map
              (
                kernelName: {
                  name = "jupyterlab-kernel-${kernelName}";
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
            jupyterlab-kernel-stable-ansible = mkJupyterlabInstance {
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
          value = import "${path}/${name}" {inherit pkgs kernels;};
        };

        /*
        Copies kernel instance folder to nix store and returns the path.

        Example:
          getKernelInstanceSource "mypython" (self + /kernels) ->
            [
              /nix/store/<hash>-jupyterlab-mypython-kernel-instance-source
              ...
            ]
        */
        getKernelInstanceSource = kernelName: kernelConfigurationsPath:
          builtins.path {
            name = "jupyterlab-${kernelName}-kernel-instance-source";
            path = kernelConfigurationsPath + "/${kernelName}";
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
          import path {inherit availableKernels name pkgs;};

        /*
        Return jupyterEvironment with ker
        Example:
          mkJupyterlabEnvironmentFromPath ./kernels ->
            <jupyterEvironment>
        */
        mkJupyterlabEnvironmentFromPath = kernelConfigurationsPath:
          mkJupyterlabInstance {
            kernels = availableKernels:
              builtins.map
              (getKernelInstance availableKernels)
              (getKernelConfigurationsFromPath kernelConfigurationsPath);
          };
      in rec {
        lib = {
          inherit
            mkJupyterlabInstance
            mkJupyterlabEnvironmentFromPath
            getKernelsFromPath
            ;
        };
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
      jupyterKernels = getKernelsFromPath (self + /kernels);
      jupyterKernelsMatrix = let
        experimental = ["cpp" "ocaml" "ruby"];
        kernelNames = builtins.attrNames kernels;
      in {
        kernel = builtins.filter (name: ! builtins.elem name experimental) kernelNames;
        experimental = [false];
      };

      templates.default = {
        path = ./template;
        description = "Boilerplate for your jupyter-nix project";
        welcomeText = builtins.readFile ./template/README.md;
      };
    };
}
