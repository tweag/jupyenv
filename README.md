# JupyterWith

The goal of this repo is to give a way to package Jupyter with arbitrary
extensions and kernels via Nix.

## How to use 

This folder has two components, `jupyterWith`, which allows to use arbitrary Nix-defined kernels and JupyterLab paths.

For example, write a `shell.nix` containing:

``` nix
with (import ./. {});

(jupyterlabWith {
  kernels = with kernels; [
    # Sample Haskell kernel
    ( iHaskellWith {
        name = "hvega";
        packages = p: with p; [
          hvega
          PyF
          formatting
          string-qq
        ];
      })

    # Sample Python kernel
    ( iPythonWith {
        name = "numpy";
        packages = p: with p; [
          numpy
        ];
      })
  ];

  directory = ./jupyterlab;
}).env
```

Kernels must be derivations containing a `kernel.json` file following the JupyterLab format.
Examples can be found in the [kernels](kernels) folder.

JupyterLab directories containing desired extensions can be generated using the `generate-directory.sh` script:

``` bash
$ ./generate-directory.sh DIRECTORY [EXTENSIONS]
$ ./generate-directory.sh jupyterlab-path jupyterlab-ihaskell jupyterlab_bokeh
```

And finally, run `nix-shell`, which will generate the necessary environment and run JupyterLab.

## Generating the directory with Nix

The `generate-directory.sh` process can also be done declaratively using Nix.
However, this is an impure process, due to the network access and dependency
resolution performed by Jupyter. In the above `shell.nix` file you can use:

``` nix
directory = import ./generate-directory.nix {
  extensions = [
    "jupyterlab-ihaskell"
    "jupyterlab_bokeh"
    "@jupyterlab/toc"
    "qgrid"
  ];
};
```

In this case, you must be sure that sandboxing is disabled in Nix.  It is
enabled by default in newer versions of Nix.  This can be done either by:

- running `nix-shell --option build-use-sandbox false`; or
- setting `build-use-sandbox = false` in `/etc/nix/nix.conf`.

## Building the Docker image

Just run:

```
$ nix-build docker.nix
$ cat result | docker load
$ docker run -v $(pwd)/example:/data -p 8888:8888 jupyterlab-ihaskell:latest
```

## Changes and Additions to the default package sets

The kernels rely on the default package sets that are provided by the imported
nix repositories. These package sets can be modified with a nix overlay, for
example to add a new python package from PIP. You can see examples of this
in the `./nix/python-overlay.nix` or `./nix/haskell-overlay.nix` files.
