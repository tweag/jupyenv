{ pkgs }:

{
  generateDirectory = pkgs.writeScriptBin "generate-directory" ''
    if [ $# -eq 0 ]
      then
        echo "Usage: generate-directory [EXTENSION]"
      else
        DIRECTORY="./jupyterlab"
        echo "Generating directory '$DIRECTORY' with extensions:"

        # we need to copy yarn.lock manually to the staging directory to get write access
        # this seems to be a bug in jupyterlab that doesn't consider that it comes from
        # a folder without read access only as in Nix
        mkdir -p "$DIRECTORY"/staging
        cp ${pkgs.python3Packages.jupyterlab}/lib/python3.7/site-packages/jupyterlab/staging/yarn.lock "$DIRECTORY"/staging
        chmod +w "$DIRECTORY"/staging/yarn.lock

        for EXT in "$@"; do echo "- $EXT"; done
        ${pkgs.python3Packages.jupyterlab}/bin/jupyter-labextension install "$@" --app-dir="$DIRECTORY"
        chmod -R +w "$DIRECTORY"/*
        rm -rf "$DIRECTORY"/staging
    fi
  '';

  mkDirectoryWith = { extensions }:
    # Creates a JUPYTERLAB_DIR with the given extensions.
    # This operation is impure
    pkgs.stdenv.mkDerivation {
      name = "jupyterlab-extended";
      phases = "installPhase";
      buildInputs = with pkgs; [ python3Packages.jupyterlab nodejs  ];
      installPhase = ''
        export HOME=$TMP

        # we need to copy yarn.lock manually to the staging directory to get write access
        # this seems to be a bug in jupyterlab that doesn't consider that it comes from
        # a folder without read access only as in Nix
        mkdir -p appdir/staging
        cp ${pkgs.python3Packages.jupyterlab}/lib/python3.7/site-packages/jupyterlab/staging/yarn.lock appdir/staging
        chmod +w appdir/staging/yarn.lock

        jupyter labextension install ${pkgs.lib.concatStringsSep " " extensions} --app-dir=appdir --debug
        rm -rf appdir/staging/node_modules
        mkdir -p $out
        cp -r appdir/* $out
      '';
    };
}
