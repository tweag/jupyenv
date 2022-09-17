# JupyterLab Templates

This readme assumes you have already initialized a project using the available templates. If not, follow the instructions in the [top level README](../README.md).

## Quick Start

As mentioned in the top level README, run the following to start JupyterLab:

```shell
nix run
```

JupyterLab will start up and you can start using it inside your browser. The default kernels generally only have standard libraries and packages available. If you want to extend the kernels to have additional libraries and packages, see the following sections.

## Kernels

### Extending Kernels

By extending a kernel, we mean modifying the arguments given to an available kernel. Open up the `kernels/python.nix` kernel and you should see something like the following:

```nix
{
  pkgs,
  availableKernels,
  kernelName,
}:
availableKernels.python.override {
  name = "custom-${kernelName}";  # must be unique
  displayName = "custom ${kernelName}";
}
```

As a simple starter, let us add `numpy` to the Python kernel and change the names to be more descriptive.

```nix
{
  pkgs,
  availableKernels,
  kernelName,
}:
availableKernels.python.override {
  name = "python-with-numpy"; # must be unique
  displayName = "python with numpy";
  extraPackages = ps: [ ps.numpy ];
}
```

We have added the `extraPackages` attribute, a function which takes a package set, `ps`, as an argument and returns a list of packages. Anything available as a python package in `nixpkgs` should be added as easily as we added numpy. For example, if we wanted to add `scipy` and `pandas`, we could modify the list to be `[ ps.numpy ps.scipy ps.pandas ]`.

We also modified the `name` and `displayName` attributes, which is not necessary, but modifying `displayName` makes it easier to distinguish from other kernels in the JupyterLab Web UI. One very important note is that if you have multiple kernel files in your project, they must all have unique `name` attributes.

Additional Info: The `extraPackages` argument is used with [poetry2nix][mkpoetryenv] and it takes a function that returns a list. We are using `mkPoetryEnv` from poetry2nix which uses `python.withPackages` -- see the related [documentation][withpackages] for details.

### Extending Kernels (Advanced)

While you can override the `extraPackages` as seen previously, you are relying on the version of the package in `nixpkgs`. If you want to specify particular versions, it is easier to extend the kernel in a different. Below is a tree structure showing where our new kernel will be created. Our new kernel will be located in `custom-python` under the `kernels` directory. We will create the `default.nix` and `pyproject.toml` files and the `poetry.lock` file will be generated for us using `poetry`.

```
my-project/
└── kernels/
    └── custom-python/
        ├── default.nix
        ├── pyproject.toml
        └── poetry.lock
```

1. The first step is to create a directory to put our new kernel which I named `custom-python`.

1. The easiest way to create the `pyproject.toml` file is to copy it from the existing kernel in the repository. I have copied the Python kernels `pyproject.toml` file and added a `numpy` dependency under `tool.poetry.dependencies`.

```toml
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

3. Generate a `poetry.lock` file by running `poetry lock` in the kernel directory, `custom-python`.

1. Below is the `default.nix` file which looks similar to the file in the [previous example](#extending-kernels). However now we are overriding the `projectDir` attribute of the available kernel and setting it to the current directory. This tells `poetry2nix` to look in the current directory for the `pyproject.toml` and `poetry.lock` files which will create a new Python kernel with the version of `numpy` that we specified. Similar to before we override the `name` and `displayName` attribute so we can distinguish it from other kernels.

```nix
{
  pkgs,
  availableKernels,
  kernelName,
}:
availableKernels.python.override {
  projectDir = ./.;
  displayName = "Python with Numpy 1.23.x";
  name = "my-python-with-numpy";
}
```

5. From the project top level directory, run `nix run`. This make take some time as new packages and dependencies have to be fetched. Eventually, you will see the recognizable messages from JupyterLab in your terminal. Open up the Web UI in your browser and use your custom kernel.

### Custom Kernels

TODO

## Extensions

### Stateful Extensions

JupyterLab extensions can be statefully installed using the CLI or Web UI as shown in the [JupyterLab Extensions documentation][jlab-extensions]. To use the CLI, the `jupyter` binary is located in the `result` directory and can be run as follows: `./result/bin/jupyter labextension install <extension>`.

### Pure Extensions

TODO

## Conventions, Structure & Terminology

To try and bridge the knowledge gap between the developers and our users, this section will discuss conventions used, kernel file structure, and terminology used to describe different stages of kernel creation. The goal is to empower you to be comfortable with modifying and extending the template files and minimize confusion in the following sections.

### What is a kernel and where is it located?

As previously mentioned, in the top level README, all kernels are located in the `kernels` directory. A kernel file located in the `kernels` directory can have virtually any name as long as it has a `.nix` file suffix. These are all valid kernel file names: `python.nix`, `go.nix`, and `my-custom-kernel.nix`.

When creating a custom kernel, it may be necessary to put the kernel file along with any supporting files, in its own directory in the `kernels` directory. For example, you can create a directory, `my-kernel`, in the `kernels` directory like so: `kernels/my-kernel/`. In `my-kernel`, your kernel file _must_ be named `default.nix`. This is a standard practice in the Nix ecosystem to make finding files easy and unabiguous.

One last note is that you can disable kernels by prefixing the kernel file or directory with an underscore. For example, if we modified the previous examples to be `_python.nix` or `_my-kernel/default.nix`, then those kernels would not be built into the JupyterLab environment and you will not see them when using the JupyterLab Web UI. This is the recommended way of temporarily hiding kernels from your environment without having to delete them. We will generally refer to kernels without the underscore prefix as enabled and kernels with the underscore prefix as disabled.

### Kernel definitions and structure

Below are some definitions we will use to minimize ambiguity and confusion in the following sections. There is no need to memorize these definitions now and we recommend skipping below to the example of a kernel file and referring back to these definitions as needed.

- available kernel: This is synonymous with a kernel file. It is a function that takes an attribute set as an argument. The applied attribute set must contain `self` and `pkgs`, and there are additional keys, such as `name` and `displayName`, that may be optionally provided.
- kernel instance: This is the available kernel with its argument applied. It returns an attribute set that is similar in structure and naming to Jupyter's kernelspec.
- kernel derivation: This is the kernel instance after being processed using internal functions. It creates a derivation that lives in the Nix store and is provided to the JupyterLab instance as an available kernel.

Below is an minimal example of how every kernel is structured. This is what you would see if you opened a kernel file (e.g. `python.nix` or `default.nix`) and what we refer to as an available kernel. In the attribute set argument, `self` and `pkgs` are required and all other keys are optional. Note that there is no actual key named `extraArgs`; this is a catchall for any and all optional keys. The optional arguments for every available kernel is unique, and rather than discuss all the possibilities, `extraArgs` is used to denote that extra arguments exist.

When extending or customizing a kernel, the `override` function can be used to modify the keys of the available kernel attribute set. Here is where you would add or modify kernel dependencies, libraries, and packages to customize the kernel to your needs. There is an example of this [above](#extending-kernels).

The available kernel is responsible for building and providing the kernel environment, `kernelEnv`, and providing that to the kernel instance. The kernel environment is what interfaces with Jupyter and handles the code the user wants to run. How each kernel environment is created is unique to each kernel and not the focus of this readme. `kernelEnv` is not actually set to `"DEEP MAGIC"` but if you want to see the deep magic, open a kernel files to see how they are built.

The kernel instance is the resulting attribute set and the fields are used to create the `kernel.json` file that Jupyter uses.

```nix
{
  self,
  pkgs,
  extraArgs ? extraArgsDefaults,
}: let
  kernelEnv = "DEEP MAGIC";
in
  {
    name = "unique kernel name";
    displayName = "pretty kernel name";
    language = "language name";
    argv = [
      "${kernelEnv}"
      "arguments"
      "to"
      "pass"
      "to"
      "jupyter"
    ];
    codemirrorMode = "language mode";
    logo32 = ./logo32.png;
    logo64 = ./logo64.png;
  }
```

[jlab-extensions]: https://jupyterlab.readthedocs.io/en/stable/user/extensions.html
[mkpoetryenv]: https://github.com/nix-community/poetry2nix/#mkpoetryenv
[withpackages]: https://nixos.org/manual/nixpkgs/stable/#python.withpackages-function
