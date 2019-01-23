# JupyterWith

This repository defines Nix expressions for JupyterLab allowing the use of
arbitrary extensions and kernels.

## Getting started

Write a `shell.nix` such as:

``` nix
let
  jupyterWith = builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = null;
  };
in

with (import jupyterWith {});

let
  jupyter =
    jupyterlabWith {
      kernels = with kernels; [

        # IHaskell kernel
        ( iHaskellWith {
            name = "hvega";
            packages = p: with p; [
              # Desired dependencies go here
              hvega
              formatting
            ];
        })

        # IPython kernel
        ( iPythonWith {
            name = "numpy";
            packages = p: with p; [
              # Desired dependencies go here
              numpy
            ];
        })
      ];
    };
in
  jupyter.env
```

and run `nix-shell`.

## Adding extensions

JupyterLab uses a solver for installing extensions. Since this process is
impure, Nix integration is hard. There are two options to overcome this
problem.

The first it to generate a JupyterLab forder manually, using the
`generate-directory.sh` script:

``` bash
$ ./generate-directory.sh [EXTENSIONS]
$ ./generate-directory.sh jupyterlab-ihaskell jupyterlab_bokeh
```

which will generate a `jupyterlab` directory with the right extensions on it.
It can be input to `jupyterWith` with:

```
jupyterlabWith {
  directory = ./jupyterlab;
}

```

Another option is to use the `mkDirectoryWith` function that comes with this
repo:


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

In this case, you must be sure that sandboxing is disabled in Nix.  It is
enabled by default in newer versions of Nix.  This can be done either by:

- running `nix-shell --option build-use-sandbox false`; or
- setting `build-use-sandbox = false` in `/etc/nix/nix.conf`.

The first option may need the use of `sudo`, depending on the version of Nix.

## Defining other kernels

Kernels are derivations containing a `kernel.json` file in the JupyterLab
format. Examples can be found in the [kernels](kernels) folder.

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
