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
  ## Import this repository
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "";
  });

  ## Declare Python kernel setup
  iPython = iPythonWith {
    name = "python kernel name";
    packages = p: with p; [ numpy ];
  };

  ## Declare Haskell kernel setup
  iHaskell = iHaskellWith {
    name = "hvega";
    packages = p: with p; [ hvega formatting ];
  };

  ## Expose kernels to JupyterLab
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

### Using extensions

Extensions can be added by generating a JupyterLab frontend directory.
This can be done by running `nix-shell` from the folder with the `shell.nix`
file and then using the `generate-directory` executable that is available from
inside the shell.

``` bash
$ generate-directory [EXTENSIONS]
$ generate-directory jupyterlab-ihaskell jupyterlab_bokeh
```

This will generate a folder called `jupyterlab` that can then be passed to
`jupyterWith`. With extensions, the example above becomes:

``` nix
let
  ## Import this repository
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "";
  });

  ## Declare Python kernel setup
  iPython = iPythonWith {
    name = "python kernel name";
    packages = p: with p; [ numpy ];
  };

  ## Declare Haskell kernel setup
  iHaskell = iHaskellWith {
    name = "hvega";
    packages = p: with p; [ hvega formatting ];
  };

  ## Expose kernels to JupyterLab
  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython iHaskell ];
      ## The generated directory goes here
      directory = ./jupyterlab;
    };
in
  jupyterEnvironment.env
```

Another option is to use the impure `mkDirectoryWith` Nix function that comes
with this repo:

``` nix
{
  jupyterEnvironment =
    jupyter.jupyterlabWith {
      kernels = [ iPython iHaskell ];
      ## The directory is generated here
      directory = mkDirectoryWith {
        extensions = [
          "jupyterlab-ihaskell"
          "jupyterlab_bokeh"
        ];
      };
    };
}
```

In this case, you must make sure that sandboxing is disabled in your Nix
configuration. Newer Nix versions have it enabled by default. Sandboxing can be
disabled:

- either by running `nix-shell --option build-use-sandbox false`; or
- by setting `build-use-sandbox = false` in `/etc/nix/nix.conf`.

The first option may require using `sudo`, depending on the version of Nix.

### Changes to the default package sets

The kernel environments rely on the default package sets that are provided by
the Nixpkgs repository that is defined in the [nix folder](nix). These package
sets can be modified using overlays, for example to add a new Python package
from PIP. You can see examples of this in the
[`./nix/python-overlay.nix`](nix/python-overlay.nix) and
[`./nix/haskell-overlay.nix`](nix/haskell-overlay.nix) files.

### Building the Docker images

One can easily Docker images from Jupyter environments defined with
JupyterWith. All that is needed is to write a `docker.nix` file in the model
of:

``` nix
let
  jupyter = import (builtins.fetchGit {
    url = https://github.com/tweag/jupyterWith;
    rev = "";
  });

  jupyterEnvironment = jupyter.jupyterlabWith {
  };
in
  ## Build the Docker image.
  jupyter.mkDockerImage {
    name = "jupyter-image";
    jupyterlab = jupyterEnvironment;
  }
```

And run `nix-build docker.nix`. The resulting image can be run as follows:

```
$ cat result | docker load
$ docker run -v $(pwd)/example:/data -p 8888:8888 jupyter-image:latest
```

## Example Notebooks

Many example notebooks are available from the [example](example) folder.  There
you can find Notebooks with various languages and different applications, and
their respective setup using JupyterWith.

## Contributing

### Kernels

JupyterWith is designed so that new kernels can be easily added, and kernel
contributions are welcome. Kernels are derivations with a `kernel.json` file
that has the JupyterLab format. Examples of these can be found in the
[kernels](kernels) folder.

### About extensions

In order to install extensions, JupyterLab runs `yarn` to resolve the precise
versions of the JupyterLab core modules, extensions, and all of their
dependencies in a way that is compatible. This resolution process is difficult
to replicate with Nix. That's why we decided to use the JupyterLab build system
for now to prebuild a custom JupyterLab version with extensions.

If you have ideas on how to make this process more declarative, feel free to
create an issue or PR.

### Nixpkgs

The final goal of this project is to be completely integrated into Nixpkgs
eventually. However, the migration path, in part due to extensions, is not
completely clear.

If you have ideas, feel free to create an issue so that we can discuss.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE)
file for details.
