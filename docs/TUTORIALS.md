# JupyterLab Templates

## Initialize a Project

Run the following commands to create a project directory, `my-project`, `cd` into it, and copy the flake template from the jupyterWith repository.

```shell
mkdir my-project
cd my-project
nix flake init --template github:tweag/jupyterWith
```

Your project directory will be populated with a `flake.nix` file and a `kernels` directory.

## Quick Start

Run the following to start JupyterLab:

```shell
nix run
```

JupyterLab will start up and you can start using it inside your browser.
The default kernels generally only have standard libraries and packages available.
If you want to extend the kernels to have additional libraries and packages, see the following sections.

## Kernels

### Extending Kernels

By extending a kernel, we mean modifying the arguments given to an available kernel.
Open up the `kernels/python.nix` kernel and you should see something like the following:

```nix title="python.nix"
{
  name,
  availableKernels,
  extraArgs,
}:
availableKernels.python {
  name = "custom-${name}";  # must be unique
  displayName = "custom ${name}";
}
```

As a simple starter, let us add `numpy` to the Python kernel and change the names to be more descriptive.

```nix title="python.nix"
{
  name,
  availableKernels,
  extraArgs,
}:
availableKernels.python {
  name = "python-with-numpy"; # must be unique
  displayName = "python with numpy";
  extraPackages = ps: [ ps.numpy ];
}
```

We have added the `extraPackages` attribute, a function which takes a package set, `ps`, as an argument and returns a list of packages.
Anything available as a python package in `nixpkgs` should be added as easily as we added numpy.
For example, if we wanted to add `scipy` and `pandas`, we could modify the list to be `[ ps.numpy ps.scipy ps.pandas ]`.

We also modified the `name` and `displayName` attributes.
Modifying `displayName` is not necessary but makes it easier to distinguish from other kernels in the JupyterLab Web UI.
One very important note is that if you have multiple kernel files in your project, they must all have unique `name` attributes.

Additional Info: The `extraPackages` argument is used with [poetry2nix][mkpoetryenv] and it takes a function that returns a list.
We are using `mkPoetryEnv` from poetry2nix which uses `python.withPackages` -- see the related [documentation][withpackages] for details.

### Extending Kernels (Advanced)

While you can provide `extraPackages` as seen previously, you are relying on the version of the package in `nixpkgs`.
If you want to specify particular versions, it is easier to extend the kernel using Poetry.
Below is a tree structure showing where our new kernel will be created.
Our new kernel will be located in `custom-python` under the `kernels` directory.
We will create the `default.nix` and `pyproject.toml` files and the `poetry.lock` file will be generated for us using `poetry`.

```
my-project/
└── kernels/
    └── custom-python/
        ├── default.nix
        ├── pyproject.toml
        └── poetry.lock
```

1. The first step is to create a directory to put our new kernel which I named `custom-python`.
1. The easiest way to create the `pyproject.toml` file is to copy it from the existing kernel in the repository.
   I have copied the Python kernels `pyproject.toml` file and added a `numpy` dependency under `tool.poetry.dependencies`.

    ```toml title="pyproject.toml"
    [tool.poetry]
    name = "jupyter-nix-kernel-ipython"
    version = "0.1.0"
    description = ""
    authors = []

    [tool.poetry.dependencies]
    python = "^3.9"
    numpy = "^1.23.0"
    ipykernel = "^6.15.0"

    [tool.poetry.dev-dependencies]
    # build systems for dependencies
    hatchling = "^1.3.1"

    [build-system]
    requires = ["poetry-core>=1.0.0"]
    build-backend = "poetry.core.masonry.api"
    ```

1. Generate a `poetry.lock` file by running `poetry lock` in the kernel directory, `custom-python`.
1. Below is the `default.nix` file which looks similar to the file in the [previous example](#extending-kernels).
   However now we are overriding the `projectDir` attribute of the available kernel and setting it to the current directory.
   This tells `poetry2nix` to look in the current directory for the `pyproject.toml` and `poetry.lock` files which will create a new Python kernel with the version of `numpy` that we specified.
   Similar to before we set the `name` and `displayName` attribute so we can distinguish it from other kernels.

    ```nix title="default.nix"
    {
      name,
      availableKernels,
      extraArgs,
    }:
    availableKernels.python {
      projectDir = ./.;
      displayName = "Python with Numpy 1.23.x";
      name = "my-python-with-numpy";
    }
    ```

1. From the project top level directory, run `nix run`.
   This make take some time as new packages and dependencies have to be fetched.
   Eventually, you will see the recognizable messages from JupyterLab in your terminal.
   Open up the Web UI in your browser and use your custom kernel.

### Custom Kernels

TODO

## Extensions

### Stateful Extensions

JupyterLab extensions can be statefully installed using the CLI or Web UI as shown in the [JupyterLab Extensions documentation][jlab-extensions].
To use the CLI, the `jupyter` binary is located in the `result` directory and can be run as follows: `./result/bin/jupyter labextension install <extension>`.

### Pure Extensions

TODO

[jlab-extensions]: https://jupyterlab.readthedocs.io/en/stable/user/extensions.html
[mkpoetryenv]: https://github.com/nix-community/poetry2nix/#mkpoetryenv
[withpackages]: https://nixos.org/manual/nixpkgs/stable/#python.withpackages-function
