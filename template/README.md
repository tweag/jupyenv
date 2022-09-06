# Simple JupyterLab Environment Template

## Getting started

This readme assumes you have already initialized a project using the project's templates. If not, follow the instructions in the [top level README](../README.md).

### Quick Start

Run the following

```shell
nix run
```

JupyterLab will start up and you can start using it inside your browser. The default kernels generally only have built in packages available. If you want to extend the kernels to have additional packages, see the following sections.

### Extending Kernels

All the kernels are in the `kernels` directory. Open up the `kernels/python.nix` kernel and you should see something like the following:

```nix
{
  pkgs,
  availableKernels,
  name,
}:
availableKernels.python {
  displayName = name;
}
```

As a simple starter, let us add `numpy` to the python kernel and change the name to be more descriptive.

```
{
  pkgs,
  availableKernels,
  name,
}:
let
  python = availableKernels.python.override {
    extraPackages = ps: [ ps.numpy ];
  };
in
  python {
    displayName = "python with numpy";
  }
```

We override the `extraPackages` argument that is used with [poetry2nix][mkpoetryenv] and provide it a function that returns a list. We are using `mkPoetryEnv` from poetry2nix which uses `python.withPackages` -- see the related [documentation][withpackages] for details. Modifying the `displayName` attribute will change the kernel name that appears in the JupyterLab Web UI; it is purely descriptive.

[mkpoetryenv]: https://github.com/nix-community/poetry2nix/#mkpoetryenv
[withpackages]: https://nixos.org/manual/nixpkgs/stable/#python.withpackages-function

### Custom Kernels

While you can override the `extraPackages` as seen previously, you are relying on the version of the package in `nixpkgs`. If you want to specify particular versions, it is easier to create a custom kernel. 

1. The first step is to create a directory to put my custom kernel. In my project directory, under the `kernels` directory, I have created a directory, `custom-python`.

2. I have copied the `pyproject.toml` file from the python kernel in the `jupyterWith` repository and modified it. The only change I have made is adding a numpy dependency.

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

3. Generate a `poetry.lock` file by running `poetry lock` in the kernel directory.

4. I am going to copy the `python.nix` file that comes with the template and modify it as shown below. Note that because our kernel has its own directory, we need to change the kernel file name from `python.nix` to `default.nix`. Notice in the overrides that we are now passing in `projectDir` and setting it to the current directory. This tells `poetry2nix` to look in the current directory for the `pyproject.toml` and `poetry.lock` files. At the end, we are setting the `displayName` and `name` attbitues. `displayName` is not required but recommended as it the name that will be displayed in the kernels list in the JupyterLab Web UI. Not setting this will give the kernel a generic name (e.g. Python3) and if you have multiple kernels of the same language, they will all have the same name appear in JupyterLab. The `name` attribute is required and needs to be unique. The is the name that JupyterLab associates with this kernel and if two kernels have the same name, there will be unforseen issues.

```nix
{
  pkgs,
  availableKernels,
  name,
}:
let
  python = availableKernels.python.override {
    projectDir = ./.;
  };
in
  python {
    displayName = "my-python";
    name = "my-python";
  }
```

5. From the project top level directory, run `nix run`. This make take some time as new packages and dependices have to be fetched. Eventually, you will see the recognizable messages from JupyterLab in your terminal. Open up the Web UI in your browser and use your custom kernel.

