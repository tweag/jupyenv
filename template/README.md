# JupyterLab Templates

This readme assumes you have already initialized a project using the available templates. If not, follow the instructions in the [top level README](../README.md).

## Conventions, Structure & Terminology

To try and bridge the knowledge gap between the developers and our users, this section will discuss conventions used, kernel file structure, and terminology used to describe different stages of kernel creation. The goal is to empower you to be comfortable with modifying and extending the template files and minimize confusion in the following sections.

### What is a kernel and where is it located?

As previously mentioned, in the top level README, all kernels are located in the `kernels` directory. A kernel file located in the `kernels` directory can have virtually any name as long as it has a `.nix` file suffix. These are all valid kernel file names: `python.nix`, `go.nix`, and `my-custom-kernel.nix`.

When creating a custom kernel, it may be necessary to put the kernel file along with any supporting files, in its own directory in the `kernels` directory. For example, you can create a directory, `my-kernel`, in the `kernels` directory like so: `kernels/my-kernel/`. In `my-kernel`, your kernel file _must_ be named `default.nix`. This is a standard practice in the Nix ecosystem to make finding files easy and unabiguous.

One last note is that you can disable kernels by prefixing the kernel file with an underscore. For example, if we modified the previous examples to be `_python.nix` or `my-kernel/_default.nix`, then those kernels would not be built into the JupyterLab environment and you will not see them when using the JupyterLab Web UI. This is the recommended way of temporarily hiding kernels from your environment without having to delete them. We will generally refer to kernels without the underscore prefix as enabled or available and kernels with the underscore prefix as disabled or unavailable.

### Kernel definitions and structure

Below are some definitions we will use to minimize ambiguity and confusion in the following sections. There is no need to memorize these definitions now and we recommend skipping below to the example of a kernel file and referring back to these definitions as needed.

- kernel factory: This is synonymous with a kernel file. It is a function that takes an attribute set as an argument. The applied attribute set must contain `self` and `pkgs`, and there are additional keys they may be optionally provided.
- kernel instance: This is a kernel factory with its argument applied. It returns a function that also takes an attribute set as an argument. All of attribute set keys are optional.
- kernel specification: This is the kernel instance with its argument applied. It returns an attribute set that is similar in structure and naming to Jupyter's kernelspec.
- kernel derivation: This is the kernel specification after being processed using internal functions. It creates a derivation that lives in the Nix store and is provided to the JupyterLab instance as an available kernel.

Below is an minimal example of how every kernel is structured. This is what you would see if you opened a kernel file (e.g. `python.nix` or `default.nix`) and what we refer to as a kernel factory. In the attribute set argument, `self` and `pkgs` are required and all other keys are optional. Note that there is no actual key named `extraArgs`; this is a catchall for any and all optional keys. The optional arguments for every kernel factory is unique, and rather than discuss all the possibilities, `extraArgs` is used to denote that extra arguments exist.

When extending or customizing a kernel, the `override` function can be used to modify the keys of the kernel factory attribute set. Here is where you would add or modify kernel dependencies, libraries, and packages to customize the kernel to your needs. There is an example of this [below](#extending-kernels).

The kernel factory is responsible for building and providing the kernel environment, `kernelEnv`, and providing that to the kernel instance. The kernel environment is what interfaces with Jupyter and handles the code the user wants to run. How each kernel environment is created is unique to each kernel and not the focus of this readme. `kernelEnv` is not actually set to `"DEEP MAGIC"` but if you want to see the deep magic, open a kernel files to see how they are built.

The kernel instance takes an attribute set and returns an attribute set of the same form. This is done to provide the user an interface to modify the values of the kernel specification to their liking. There is an example of this [below](#extending-kernels).

```
{
  self,
  pkgs,
  extraArgs ? extraArgsDefaults,
}: let
  kernelEnv = "DEEP MAGIC";
in
  {
    name ? "unique kernel name",
    displayName ? "pretty ",
    language ? "language name",
    argv ? [
      "${kernelEnv}"
      "arguments"
      "to"
      "pass"
      "to"
      "jupyter"
    ],
    codemirrorMode ? "language mode",
    logo32 ? ./logo32.png,
    logo64 ? ./logo64.png,
  }: {
    inherit
      name
      displayName
      language
      argv
      codemirrorMode
      logo32
      logo64
      ;
  }
```

## Quick Start

As mentioned in the top level README, run the following to start JupyterLab:

```shell
nix run
```

JupyterLab will start up and you can start using it inside your browser. The default kernels generally only have standard libraries and packages available. If you want to extend the kernels to have additional libraries and packages, see the following sections.

## Kernels

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

