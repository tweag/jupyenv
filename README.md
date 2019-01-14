# JupyterWith

The goal of this repo is to give a way to package Jupyter with arbitrary
extensions and kernels via Nix.

## How to use 

The `default.nix` file in this folder contains two components: the
`jupyterlabWith` takes a list of kernel derivations and a path with a prebuild
jupyterapp as input. The prebuild jupyterlab can contain a set of extensions.

For example, a `shell.nix` that starts Jupyterlab with two kernels could look
like:

``` nix
with (import ./. {});

(jupyterlabWith {
  kernels = with kernels; [

    ( iHaskellWith {
        name = "hvega";
        packages = p: with p; [
          hvega
          PyF
          formatting
          string-qq
        ];
      })

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

Kernels must be derivations containing a `kernel.json` file in the JupyterLab
format. Examples can be found in the [kernels](kernels) folder.

The custom JupyterLab app that contains a set of extensions can be generated in
`./jupyterlab` with the `generate-directory.sh` script:

``` bash
$ ./generate-directory.sh [EXTENSIONS]
$ ./generate-directory.sh jupyterlab-ihaskell jupyterlab_bokeh
```

Running `nix-shell` will generate the environment and start JupyterLab.

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

## Custom Kernels
A custom kernel file can also be provided via command line argument. The cities
wordcloud example contains the example file [`kernelWith.nix`](./example/cities-wordcloud/kernelWith.nix)
that defines the kernel as follows:

```
{ iHaskellWith }:

iHaskellWith {
  name="cities-wordcloud";
  packages = p: with p; [
          hvega
          PyF
          formatting
          string-qq
        ];
      }
```

Jupyterlab can be run with this kernel with `nix-shell --arg kernelFile ./example/cities-wordcloud/kernelWith.nix`
from the root of this repository.

The example file `kernelWith.nix` depends on the `iHaskellWith` function and is
therefore not a fully isolated description of the compute environment in which
the notebook should be executed. It is possible to add a longer fully
self-contained `kernelWith.nix` file to get a truly reproducible setup for the
notebook.

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
