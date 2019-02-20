{ pkgs }:

{
  generateDirectory = pkgs.writeScriptBin "generate-directory" ''
    if [ $# -eq 0 ]
      then
        echo "Usage: generate-directory [EXTENSION]"
      else
        DIRECTORY="./jupyterlab"
        echo "Generating directory '$DIRECTORY' with extensions:"
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
        jupyter labextension install ${pkgs.lib.concatStringsSep " " extensions} --app-dir=$out
        rm -rf $out/staging/node_modules
      '';
    };
}
