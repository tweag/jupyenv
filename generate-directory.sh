#!/usr/bin/env nix-shell
#! nix-shell --pure -I nixpkgs=./nix -i bash -p python36Packages.jupyterlab -p nodejs

if [ $# -eq 0 ]
  then
    echo "Usage: $0 [EXTENSION]"
  else
    DIRECTORY="./jupyterlab"
    echo "Generating directory '$DIRECTORY' with extensions:"
    for EXT in "$@"; do echo "- $EXT"; done
    jupyter labextension install "$@" --app-dir="$DIRECTORY"
    chmod -R +w "$DIRECTORY"/*
    rm -rf "$DIRECTORY"/staging/node_modules
fi

