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
  inputs.nix-dart.url = "github:djacu/nix-dart";
  inputs.nix-dart.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nix-dart.inputs.flake-utils.follows = "flake-utils";
  inputs.npmlock2nix.url = "github:nix-community/npmlock2nix/0ba0746d62974403daf717cded3f24c617622bc7";
  inputs.npmlock2nix.flake = false;
  inputs.opam-nix.url = "github:tweag/opam-nix/75199758e1954f78286e7e79c0e3916e28b732b0";
  inputs.opam-nix.inputs.flake-compat.follows = "flake-compat";
  inputs.opam-nix.inputs.flake-utils.follows = "flake-utils";
  inputs.opam-nix.inputs.nixpkgs.follows = "nixpkgs";
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
    nix-dart,
    npmlock2nix,
    opam-nix,
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

    kernelLib = import ./lib/kernels.nix {inherit lib;};

    kernelsConfig = kernelLib._getKernelsFromPath (self + /kernels);
  in
    (flake-utils.lib.eachSystem SYSTEMS (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};

        python = pkgs.python3;
        poetry2nixPkgs = import "${poetry2nix}/default.nix" {inherit pkgs poetry;};
        poetry = pkgs.callPackage "${poetry2nix}/pkgs/poetry" {inherit python;};

        baseArgs = {
          inherit self system;
        };

        pre-commit = pre-commit-hooks.lib.${system}.run {
          src = self;
          hooks = {
            alejandra.enable = true;
            typos = {
              enable = true;
              types = ["file"];
              files = "\\.((txt)|(md)|(nix)|\\d)$";
            };
          };
          excludes = ["^\\.jupyter/"]; # JUPYTERLAB_DIR
          settings = {
            typos.write = true;
          };
        };

        mkdocs = python.withPackages (p: [
          p.mkdocs
          p.mkdocs-material
          p.mkdocs-material-extensions
          p.markdown-it-py
          p.beautifulsoup4
          p.docopt
        ]);

        sass = pkgs.callPackage (self + "/dart-sass") {
          inherit lib;
          inherit (pkgs) stdenv fetchzip;
          buildDartPackage = nix-dart.builders."${system}".buildDartPackage;
        };

        docs = pkgs.stdenv.mkDerivation {
          name = "jupyenv-docs";
          src = self;
          nativeBuildInputs = [mkdocs sass];
          buildPhase = ''
            sass docs/sass/home/style.scss docs/stylesheets/home.css
            cp ${options.optionsJSON}/share/doc/nixos/options.json ./options.json
            python docs/python-scripts/options.py html ./options.json docs/overrides/optionsContent.html
            mkdocs build --site-dir dist
          '';
          installPhase = ''
            mkdir $out
            cp -R dist/* $out/
            cp ${options.optionsJSON}/share/doc/nixos/options.json $out/options.json
          '';
        };

        jupyterlabEnvWrapped = import (self + "/jupyterlab.nix");

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

          jupyterlabEnv = jupyterlabEnvWrapped (baseArgs // jupyterlabEnvArgs);

          # create directories for storing jupyter configs
          jupyterDir = pkgs.runCommand "jupyter-dir" {} ''
            # make jupyter config and data directories
            mkdir -p $out/config $out/data
            echo "c.NotebookApp.use_redirect_file = False" > $out/config/jupyter_notebook_config.py

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
            {
              nativeBuildInputs = [pkgs.makeWrapper];
              meta.mainProgram = "jupyter-lab";
              passthru = {
                kernels = builtins.listToAttrs (
                  builtins.map
                  (k: {
                    name = k.name;
                    value = k;
                  })
                  kernelDerivations
                );
              };
            }
            (''
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
              ''
              + (lib.strings.optionalString (
                  builtins.any
                  (kernel: kernel.kernelInstance.language == "julia")
                  kernelDerivations
                ) ''
                  # add Julia for IJulia
                  echo 'Adding Julia as an available package.'
                  for i in ${pkgs.julia}/bin/*; do
                    filename=$(basename $i)
                    ln -s ${pkgs.julia}/bin/$filename $out/bin/$filename
                  done
                ''));

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
              (kernelLib.getKernelAttrsetFromPath kernelsPath []);
          };

        /*
        NixOS Modules stuff
        */
        mkJupyterlabEval = customModule:
          pkgs.lib.evalModules {
            specialArgs = {inherit self system mkJupyterlab;};
            modules = lib.flatten (
              [./modules]
              ++ lib.optional (customModule != null) customModule
            );
          };

        mkJupyterlabNew = customModule:
          (mkJupyterlabEval customModule).config.build;

        exampleJupyterlabKernelsNew = (
          lib.mapAttrs'
          (
            name: value:
              lib.nameValuePair
              ("jupyterlab-kernel-" + name)
              (mkJupyterlabNew value)
          )
          kernelsConfig.kernels
        );

        exampleJupyterlabAllKernelsNew =
          mkJupyterlabNew (builtins.attrValues kernelsConfig.kernels);

        eval = mkJupyterlabEval ({...}: {_module.check = false;});
        options = pkgs.nixosOptionsDoc {
          options = builtins.removeAttrs eval.options ["_module"];
        };
      in rec {
        lib = {
          inherit
            mkJupyterlab
            mkJupyterlabFromPath
            mkJupyterlabNew
            ;
        };
        packages =
          {
            jupyterlab-new = mkJupyterlabNew ./config.nix;
            jupyterlab = jupyterlabEnvWrapped baseArgs;
            jupyterlab-all-example-kernels = exampleJupyterlabAllKernelsNew;
            pub2nix-lock = nix-dart.packages."${system}".pub2nix-lock;
            update-poetry-lock =
              pkgs.writeShellApplication
              {
                name = "update-poetry-lock";
                runtimeInputs = [poetry];
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
            default = jupyterlabEnvWrapped baseArgs;
          }
          // exampleJupyterlabKernelsNew;
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.typos
            poetry2nixPkgs.cli
            poetry
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
          jupyterlabEnv = jupyterlabEnvWrapped baseArgs;
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
        description = "Boilerplate for your jupyenv project";
        welcomeText = ''
          You have created a jupyenv template.

          Run `nix run` to immediately try it out.

          See the jupyenv documentation for more information.

            https://jupyenv.io/documentation/getting-started/
        '';
      };
    };
}
