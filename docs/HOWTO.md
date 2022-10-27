# Basics

## Initialize a Project

When you want to create a new project, make a project directory (e.g. `my-project`) and `cd` into it.
Run the following command.

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

## Julia kernel

The Julia kernel requires some stateful operations to work properly.
If you have not initialized a project yet, do so with the following commands.

```shell
mkdir my-project
cd my-project
nix flake init --template github:tweag/jupyterWith
```

1. Build the project with `nix build .#`.
1. Enter the Julia REPL with `./result/bin/julia`.
1. Follow the commands from [IJulia](https://julialang.github.io/IJulia.jl/stable/manual/installation/#Installing-IJulia) documentation to install IJulia.
   ```
   julia
   julia> using Pkg
   julia> Pkg.add("IJulia")
   ```
1. After installing IJulia, make sure you exit the Julia REPL and are back at the top level of your project folder.
1. Start the JupyterLab environment with `nix run`.

# Kernels

## Enable kernels

After initializing your project with a flake template, it should have a `kernels` directory which contains all the kernels.
Any kernels prefixed with an underscore is disabled.
To enable any kernel, rename it so it no longer has an underscore prefix.

```shell
cp kernels/_python.nix kernels/my-python.nix
```

Notice that we gave the kernel file a new name, `my-python.nix`.
You can have multiple kernels in the same project!
We recommend you give each one a descriptive file name to help you remember in the future.

# Extensions

Extensions are currently being worked on to be reproducible.
