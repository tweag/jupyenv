# Basics

## Initialize a Project

When you want to create a new project, make a project directory (e.g. `my-project`) and `cd` into it. Run the following command.

```shell
nix flake init --template github:tweag/jupyterWith
```

Your project directory will be populated with a `flake.nix` file and a `kernels` directory.

## Starting JupyterLab

Make sure you are in the top directory of your project (e.g. `my-project`), and run the following command.

```shell
nix run
```

The environment should start up with instructions on what to do next.

# Kernels

## Enable kernels

After initializing your project with a flake template, it should have a `kernels` directory which contains all the kernels. Any kernels prefixed with an underscore is disabled. To enable any kernel, rename it so it no longer has an underscore prefix.

```shell
cp kernels/_python.nix kernels/my-python.nix
```

Notice that we gave the kernel file a new name, `my-python.nix`. You can have multiple kernels in the same project! We recommend you give each one a descriptive file name to help you remember in the future.

# Extensions

Extensions are currently being worked on to be reproducible.
