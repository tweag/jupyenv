{ pkgs ? import ./nix {} }:

let
  # Python version setup.
  python3 = pkgs.python3.pkgs;
  pythonPath = python3.makePythonPath [
    python3.ipykernel
    python3.jupyter_contrib_core
    python3.jupyter_nbextensions_configurator
    python3.tornado
  ];

  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};
  kernelsDefault = [ (kernels.iPythonWith {}) ];
  mkKernelsString = pkgs.lib.concatMapStringsSep ":" (k: "${k}");

  # Extension directory generation.
  mkDirectoryWith = { extensions }:
    import ./generate-directory.nix { inherit pkgs extensions; };
  directoryDefault = "${python3.jupyterlab}/share/jupyter/lab";

  generator = pkgs.writeScriptBin "generate-jupyterlab-directory" ''
    if [ $# -eq 0 ]
      then
        echo "Usage: generate-jupyterlab-directory [EXTENSION]"
      else
        DIRECTORY="./jupyterlab"
        echo "Generating directory '$DIRECTORY' with extensions:"
        for EXT in "$@"; do echo "- $EXT"; done
        ${python3.jupyterlab}/bin/jupyter-labextension install "$@" --app-dir="$DIRECTORY"
        chmod -R +w "$DIRECTORY"/*
        rm -rf "$DIRECTORY"/staging
    fi
  '';

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlabWith = { directory ? directoryDefault, kernels ? kernelsDefault }:
      let
       # folders.
       jupyterlab = python3.toPythonModule (
           python3.jupyterlab.overridePythonAttrs (oldAttrs: {
             makeWrapperArgs = [
               "--set JUPYTERLAB_DIR ${directory}"
               "--set JUPYTER_PATH ${mkKernelsString kernels}"
               "--set PYTHONPATH ${pythonPath}"
             ];
           })
           );

       # Shell with the appropriate JupyterLab, launching it at startup.
       env = pkgs.mkShell {
             name = "jupyterlab-shell";
             buildInputs = [ jupyterlab generator ];
             shellHook = ''
               export JUPYTERLAB=${jupyterlab}
             '';
           };
    in
      jupyterlab.override (oldAttrs: {
        passthru = oldAttrs.passthru or {} // { inherit env; };
      });

  mkDockerImage = jupyterLab:
    pkgs.dockerTools.buildImage {
      name = "jupyterlab-ihaskell";
      tag = "latest";
      created = "now";
      contents = [ jupyterLab pkgs.glibcLocales ];
      config = {
        Env = [
             "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
             "LANG=en_US.UTF-8"
             "LANGUAGE=en_US:en"
             "LC_ALL=en_US.UTF-8"
              ];
        CMD = [ "/bin/jupyter-lab" "--ip=0.0.0.0" "--no-browser" "--allow-root" ];
        WorkingDir = "/data";
        ExposedPorts = {
          "8888" = {};
        };
        Volumes = {
          "/data" = {};
        };
      };
    };

in
  { inherit jupyterlabWith kernels mkDirectoryWith mkDockerImage; }
