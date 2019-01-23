# JupyterWith

This repository defines Nix expressions for JupyterLab. It can be configured to
use arbitrary extensions and kernels.

## Getting started

The simplest use case is to write a `shell.nix` such as:

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

and run `nix-shell --command "jupyter lab"`. This can take a while, especially
when it is run for the first time because all dependencies of jupyter-lab have
to be installed. Subsequent runs should be much faster, even when some packages
or kernels are changed.

## Adding extensions

JupyterLab uses a solver that determines which the precise versions of the
jupyterlab core modules and the extensions that are used. This process is
and impure process and difficult to integrate directly in Nix. We have setup
two methods to overcome this problem:

The first it to prebuild the JupyterLab app into a folder using the
`generate-jupyterlab-directory.sh` script:

``` bash
$ generate-jupyterlab-directory.sh [EXTENSIONS]
$ generate-jupyterlab-directory.sh jupyterlab-ihaskell jupyterlab_bokeh
```

It will generate a `jupyterlab` directory that with a compiled jupyterlab app
with the right extensions on it. This custom jupyterlab folder can then be
passed to `jupyterWith` with:

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

Another option is to use the impure `mkDirectoryWith` nix function that comes
with this repo:


``` nix
jupyterlabWith {
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

## Changes to the default package sets

The kernels rely on the default package sets that are provided by the imported
Nix repositories. These package sets can be modified using overlays, for
example to add a new Python package from PIP. You can see examples of this
in the [`./nix/python-overlay.nix`](nix/python-overlay.nix) and
[`./nix/haskell-overlay.nix`](nix/haskell-overlay.nix) files.
