# Basics

## Initialize a Project

When you want to create a new project, make a project directory (e.g. `my-project`) and `cd` into it.
Run the following command.

```shell
nix flake init --template github:tweag/jupyenv
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
nix flake init --template github:tweag/jupyenv
```

1. Build the project with `nix build .#`.
1. Enter the Julia REPL with `./result/bin/julia`.
1. Follow the commands from [IJulia](https://julialang.github.io/IJulia.jl/stable/manual/installation/#Installing-IJulia) documentation to install IJulia.
   ```julia
   julia
   julia> using Pkg
   julia> Pkg.add("IJulia")
   ```
1. After installing IJulia, make sure you exit the Julia REPL and are back at the top level of your project folder.
1. Start the JupyterLab environment with `nix run`.

??? question "Did something go wrong?"

    If a Julia kernel builds fine, but you get an error when trying to open a notebook, see if one of the error messages looks like the following.

    ``` shell
    ERROR: SystemError: opening file "/home/<USER>/.julia/packages/IJulia/<SLUG>/src/kernel.jl": No such file or directory
    ```

    Here are some possible problems and how to fix them. It can be more than one.

    1. The version of IJulia you have installed does not match what jupyenv expects.
    Check the version slug of IJulia with `ls ~/.julia/packages/IJulia/`.
    If this is different than the default value, you can override it by adding the following line to your kernel configuration.
    ``` nix
      kernel.julia.<name>.ijuliaRev = <SLUG>;
    ```

    2. Your depot path is not the default.
    If your Julia packages are not installed in `"~/.julia"`, you can override it by adding the following line to your kernel configuration.
    ``` nix
      kernel.julia.<name>.julia_depot_path = <PATH>;
    ```

# Kernels

After initializing your project with a flake template, it should have a `kernels` directory, which contains `python.nix` kernel. You can find more kernel derivations in `kernels` directory at the root of this repository.

## Disabling kernels

Any kernels prefixed with an underscore is disabled. To disable a kernel, rename the file with an underscore prefix.

```shell
mv kernels/python.nix kernels/_python.nix
```

If you have started using Poetry, you will have a folder which contains a `default.nix`, `poetry.lock`, and `pyproject.toml` as shown below.

```shell
$ tree kernels
kernels
├── python.nix
└── python-numpy
    ├── default.nix
    ├── poetry.lock
    └── pyproject.toml
```

You can rename the folder in the same way to disable that kernel.

```shell
mv kernels/python-numpy kernels/_python-numpy
```

## Enable kernels

To enable any kernel, rename it so it no longer has an underscore prefix.

```shell
mv kernels/_python.nix kernels/python.nix
```

## Kernel file names

You can have multiple kernels of the same type in the same project!
We recommend you give each one a descriptive file name to help you remember in the future.
For example, the following kernels directory has 4 valid kernels.

```shell
$ tree kernels
kernels
├── python.nix
├── python-project-A.nix
├──── python-numpy
│   ├── default.nix
│   ├── poetry.lock
│   └── pyproject.toml
└──── python-project-B
    ├── default.nix
    ├── poetry.lock
    └── pyproject.toml
```

# Extensions

Extensions are currently being worked on to be reproducible.
