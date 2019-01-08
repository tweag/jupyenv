#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./nix -i bash -p python36Packages.jupyterlab
echo $JUPYTERLAB_DIR
jupyter labextension install jupyterlab-ihaskell jupyterlab_bokeh @jupyterlab/toc qgrid --app-dir=./jupyterlab
chmod -R +w ./jupyterlab/*
