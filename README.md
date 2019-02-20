# JupyterWith

[![Build Status](https://travis-ci.com/tweag/jupyterWith.svg?branch=master)](https://travis-ci.com/tweag/jupyterWith)

This repository provides a Nix-based framework for the definition of
declarative and reproducible Jupyter environments.
It provides:

- a declarative setup of Jupyter kernels;
- a declarative setup of the libraries exposed to these kernels;
- a flexible use of arbitrary extensions.

All the setup needed by Jupyter notebook can be written in a single `shell.nix`
file, which can be distributed together with the notebook, guaranteeing a
reproducible experience.

The currently supported kernels are:

- [IPython](https://github.com/ipython/ipykernel)
- [IHaskell](https://github.com/gibiansky/IHaskell)
- [CKernel](https://github.com/brendan-rius/jupyter-c-kernel)
- [IRuby](https://github.com/SciRuby/iruby)
- [Juniper RKernel](https://github.com/JuniperKernel/JuniperKernel)
- [Ansible Kernel](https://github.com/ansible/ansible-jupyter-kernel)

## Getting started

In order to use JupyterWith, [nix](https://nixos.org/nix/) must be installed.
A simple JupyterLab environment with kernels, but without extensions can be
setup by writing a `shell.nix` file such as:

``` nix
let
  # Import this repository
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "";
  });

  # Declare Python kernel setup
  iPython = iPythonWith {
    name = "python kernel name";
    packages = p: with p; [ numpy ];
  };

  # Declare Haskell kernel setup
  iHaskell = iHaskellWith {
    name = "hvega";
    packages = p: with p; [ hvega formatting ];
  };

  # Expose kernels to JupyterLab
  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython iHaskell ];
    };
in
  jupyterEnvironment.env
```

JupyterLab can then be started by running:

```
nix-shell --command "jupyter lab"
```

This can take a while, especially when it is run for the first time because all
dependencies of JupyterLab have to be installed. Subsequent runs should be much
faster, even when some packages or kernels are changed, since all the common
dependencies will be cached.

## Using extensions

When a new extension is installed, JupyterLab runs yarn to resolve the precise
versions of the jupyterlab core modules, extensions, and all of their
dependencies. This resolver process is difficult to replicate with Nix. We
therefore decided to use the JupyterLab build system for now to prebuild a
custom JupyterLab version with extensions that can then be passed to the
`jupyterlabWith` function. Two options are available to prebuild JupyterLab
with extensions:

The first one is to use the `generate-directory.sh` script:

``` bash
$ generate-directory.sh [EXTENSIONS]
$ generate-directory.sh jupyterlab-ihaskell jupyterlab_bokeh
```

This executable is also available from inside the JupyterWith Nix shell.

It will build JupyterLab with extensions into the `jupyterlab` folder
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

The second option is to use the impure `mkDirectoryWith` Nix function that
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
    };
```

In this case, you must make sure that sandboxing is disabled in your Nix
configuration. Newer Nix versions have it enabled by default.
Sandboxing can be disabled:

- either by running `nix-shell --option build-use-sandbox false`; or
- by setting `build-use-sandbox = false` in `/etc/nix/nix.conf`.

The first option may require using `sudo`, depending on the version of Nix.

## Changes to the default package sets

The kernel environments rely on the default package sets that are provided by
the nixpkgs repository that is defined in [the nix folder](nix). These package
sets can be modified using overlays, for example to add a new Python package
from PIP. You can see examples of this in the
[`./nix/python-overlay.nix`](nix/python-overlay.nix) and
[`./nix/haskell-overlay.nix`](nix/haskell-overlay.nix) files.


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

