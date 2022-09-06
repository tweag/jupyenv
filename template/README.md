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

We override the `extraPackages` argument that is used with [poetry2nix][mkpoetryenv] and provide it a function that returns a list. We are using `mkPoetryEnv` from poetry2nix which uses `python.withPackages` -- see the related [documentation][withpackages] for details. Modifying the `displayName` attribute will change the kernel name that appears in the JupyterLab Web UI.

[mkpoetryenv]: https://github.com/nix-community/poetry2nix/#mkpoetryenv
[withpackages]: https://nixos.org/manual/nixpkgs/stable/#python.withpackages-function


