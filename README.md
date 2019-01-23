# JupyterWith

This repository defines various Nix expressions that can be used to setup
JupyterLab with various extensions and various kernels. The JupyterLab
environment is setup by a nix function `jupyterlabWith` that takes kernel
environments and a optionally a custom jupyterlab app with extensions as input.
The kernel environments are also setup by nix functions such as `iPythonWith`
or `iHaskellWith` and configurable with different libraries.

## Getting started

The simplest use case (JupyterLab without extensions) is to write a `shell.nix`
file such as:

``` nix
let
  jupyterWith = builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "";
  };
in

with (import jupyterWith {});

let
  jupyter =
    jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "hvega";
            packages = p: with p; [ hvega formatting ];
          })
        ( iPythonWith {
            name = "numpy";
            packages = p: with p; [ numpy ];
          })
      ];
    };
in
  jupyter.env
```

JupyterLab can be started from the same folder with `nix-shell --command
"jupyter lab"`. This can take a while, especially when it is run for the first
time because all dependencies of JupyterLab have to be installed. Subsequent
runs should be much faster, even when some packages or kernels are changed.

## Changes to the default package sets

The kernel environments rely on the default package sets that are provided by
the nixpkgs repository that is defined in [the nix folder](nix). These package
sets can be modified using overlays, for example to add a new Python package
from PIP. You can see examples of this in the
[`./nix/python-overlay.nix`](nix/python-overlay.nix) and
[`./nix/haskell-overlay.nix`](nix/haskell-overlay.nix) files.

## Adding extensions

When a new extension is installed, JupyterLab runs yarn to resolve the precise
versions of the jupyterlab core modules, extensions, and all of their
dependencies. This resolver process is difficult to replicate with Nix. We
therefore decided to use the JupyterLab build system for now to prebuild a
custom JupyterLab version with extensions that can then be passed to the
`jupyterlabWith` function. Two options are available to prebuild JupyterLab
with extensions:

The first one is to use the `generate-jupyterlab-directory.sh` script:

``` bash
$ generate-jupyterlab-directory.sh [EXTENSIONS]
$ generate-jupyterlab-directory.sh jupyterlab-ihaskell jupyterlab_bokeh
```

It will build JupyterLab with extensions into a `jupyterlab` directory folder
that can then be passed to `jupyterWith` with:

``` nix
    jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "hvega";
            packages = p: with p; [ hvega formatting ];
          })
        ( iPythonWith {
            name = "numpy";
            packages = p: with p; [ numpy ];
          })
      ];
      directory = ./jupyterlab;
    };
```

The second option is to use the impure `mkDirectoryWith` nix function that
comes with this repo:


``` nix
jupyterlabWith {
      kernels = with kernels; [
        ( iHaskellWith {
            name = "hvega";
            packages = p: with p; [ hvega formatting ];
          })
        ( iPythonWith {
            name = "numpy";
            packages = p: with p; [ numpy ];
          })
      ];

      directory = mkDirectoryWith {
        extensions = [
          "jupyterlab-ihaskell"
          "jupyterlab_bokeh"
          "@jupyterlab/toc"
          "qgrid"
        ];
};
```

In this case, you must make sure that sandboxing is disabled in your Nix
configuration. Newer Nix versions have it enabled by default. 
Sandboxing can be disabled:

- either by running `nix-shell --option build-use-sandbox false`; or
- by setting `build-use-sandbox = false` in `/etc/nix/nix.conf`.

The first option may require using `sudo`, depending on the version of Nix.

## Defining other kernels

Kernels are derivations with a `kernel.json` file that has the JupyterLab
format. Examples of kernel derivations can be found in the [kernels](kernels)
folder.

## Building the Docker images

Just run:

```
$ nix-build docker.nix
$ cat result | docker load
$ docker run -v $(pwd)/example:/data -p 8888:8888 jupyterlab-ihaskell:latest
```

The creation of these images is managed by the `mkDockerImage` function. An
example can be seen on the [`docker.nix`](docker.nix) file.

