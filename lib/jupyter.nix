{
  self,
  system,
  pkgs,
  lib,
  baseArgs,
  kernelLib,
}: rec {
  jupyterlabEnvWrapped = {
    self,
    system,
    poetry2nix ? self.inputs.poetry2nix,
    pkgs ?
      import self.inputs.nixpkgs {
        inherit system;
        overlays = [poetry2nix.overlay];
      },
    # https://github.com/nix-community/poetry2nix#mkPoetryEnv
    projectDir ? self, # TODO: only include relevant files/folders
    pyproject ? projectDir + "/pyproject.toml",
    poetrylock ? projectDir + "/poetry.lock",
    overrides ? import ./overrides.nix pkgs,
    python ? pkgs.python3,
    editablePackageSources ? {},
    extraPackages ? (ps: []),
    preferWheels ? false,
    groups ? [],
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
          >&2 echo "[$(date +'%Y-%m-%d %H:%M:%S') jupyenv] needs to build JupyterLab."
          # we need to build the jupyter lab environment before it can be used
          ${jupyterlabEnvBase}/bin/jupyter lab build
        else
          >&2 echo "[$(date +'%Y-%m-%d %H:%M:%S') jupyenv] does not need build JupyterLab."
          >&2 echo "[$(date +'%Y-%m-%d %H:%M:%S') jupyenv] Starting..."
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
      ''
      + (kernelLib.copyKernelSpec kernelLogos kernelInstance)
      + (kernelLib.copyKernelLogos kernelLogos kernelInstance)
    );

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

    kernelDerivations = kernels;

    jupyterlabEnv = jupyterlabEnvWrapped (baseArgs // jupyterlabEnvArgs);

    # create directories for storing jupyter configs
    jupyterDir = pkgs.runCommand "jupyter-dir" {} ''
      # make jupyter config and data directories
      mkdir -p $out/config $out/data
      echo "c.NotebookApp.use_redirect_file = False" > $out/config/jupyter_notebook_config.py

      # make jupyter lab user settings and workspaces directories
      mkdir -p $out/config/lab/{user-settings,workspaces}
    '';
  in
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
            --set JUPYTER_PATH "${lib.concatStringsSep ":" kernelDerivations}" \
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
  NixOS Modules stuff
  */
  mkJupyterlabEval = customModule:
    pkgs.lib.evalModules {
      specialArgs = {inherit self system mkJupyterlab mkKernel;};
      modules = lib.flatten (
        [../modules]
        ++ lib.optional (customModule != null) customModule
      );
    };

  mkJupyterlabNew = customModule:
    (mkJupyterlabEval customModule).config.build;

  eval = mkJupyterlabEval ({...}: {_module.check = false;});

  options = pkgs.nixosOptionsDoc {
    options = builtins.removeAttrs eval.options ["_module"];
  };
}
