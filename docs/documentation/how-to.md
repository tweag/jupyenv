## Basics

### Initialize a Project

Run the following commands to create a project directory, `my-project`, `cd` into it, and copy the flake template from the jupyenv repository.

``` shell
mkdir my-project
cd my-project
nix flake init --template github:tweag/jupyenv
```

Your project directory will be populated with `flake.nix` and `kernels.nix` files.

### Starting JupyterLab

Make sure you are in the top directory of your project (e.g. `my-project`), and run the following command.

```shell
nix run
```

The environment should start up with instructions on what to do next.

## Kernels

After initializing your project with a flake template, it should have a `kernels.nix` file, with a minimally configured Python kernel.

### Enable kernels

To enable any kernel, add a line like the following to the `kernels.nix` file.

``` nix
kernel.<kernelType>.<kernelName>.enable = true;
```

`<kernelType>` is any of the kernels jupyenv supports (e.g. `python`, `julia`, `ocaml`, etc).
`<kernelName>` can be virtually anything you want and is used so you can have multiple kernels of the same type with different configurations (e.g. `example`, `scientific`, `testing`, etc).

??? warning "Conditions on `<kernelName>`"

    `<kernelName>` does have some limitations and must only contain ASCII letters, ASCII numbers, and the simple separators: `-` hyphen, `.` period, `_` underscore.
    This limitation is because `<kernelName>` makes up part of the kernel specs name that Jupyter uses.
    See the [relevant documentation](https://jupyter-client.readthedocs.io/en/stable/kernels.html#kernel-specs) if you are interested.

    Additionally, because Nix uses period as separator for attribute sets, a `<kernelName>` with a period must be enclosed in double quotes (e.g. `"my.example"`).

The following is an example `kernels.nix` file with multiple enabled kernels.

``` nix
{...}: {
  kernel.python.scientific.enable = true;
  kernel.python.aiml.enable = true;
  kernel.julia.learning-math.enable = true;
  kernel.ocaml."functional.stuff".enable = true;
  kernel.bash.scripting_cli.enable = true;
}
```

### Modifying kernel default options

To modify a kernel option, add a line like the following to the `kernels.nix` file.
See the [Options](../options/) page for the available options for each kernel.

``` nix
kernel.<kernelType>.<kernelName>.<option> = <value>;
```

The following is an example `kernels.nix` file with a Python kernel and different options being set.

``` nix
{...}: {
  kernel.python.example.enable = true;
  kernel.python.example.displayName = "My Example Python Kernel";
  kernel.python.example.extraPackages = ps: [ps.numpy ps.scipy];
}
```

??? warning "Conditions on the `name` option"

    Every kernel has a `name` option.
    Generally, you will not have to and should not change this value.
    If you do need to override the default, there are some limitations to be aware of.

    - The `name` option has the same character limitations as `<kernelName>` as described in the "Conditions on `<kernelName>`" admonition above.
    - `name` must only contain ASCII letters, ASCII numbers, and the simple separators: `-` hyphen, `.` period, `_` underscore.
    - It is the exact value of the [kernel spec name](https://jupyter-client.readthedocs.io/en/stable/kernels.html#kernel-specs) and must be unique.
    For example, the following configuration would cause unforeseen problems or might not build at all.
    ``` nix
    {...}: {
      ...
      kernel.python.example_1.name = "my-example-python";
      kernel.python.example_2.name = "my-example-python";
      ...
    }
    ```

### Python kernel with Poetry

While you can use the `extraPackages` option, you are relying on the versions of the Python packages in `nixpkgs`.
If you want to specify particular package versions, it is easier to use the `projectDir` option and use Poetry.

Below is a tree structure showing what our project directory will look like when we are done.
Our new kernel will need a directory to hold files, `my-custom-python`.
We will create the `pyproject.toml` file and the `poetry.lock` file will be generated for us using Poetry.

```
my-project/
├── flake.nix
├── kernels.nix
└── my-custom-python/
    ├── pyproject.toml
    └── poetry.lock
```

1. Create a directory to put our new kernel (e.g. `my-custom-python`).
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

1. Generate a `poetry.lock` file by running `poetry lock` in the kernel directory, `my-custom-python`.
1. Modify the kernels.nix file by adding the following lines.
``` nix title="kernels.nix"
kernel.python.python-with-numpy.enable = true;
kernel.python.python-with-numpy.projectDir = ./my-custom-python;
```

1. From the project top level directory, run `nix run`.
   This make take some time as new packages and dependencies have to be fetched.
   Eventually, you will see the recognizable messages from JupyterLab in your terminal.
   Open up the Web UI in your browser and use your custom kernel.

??? question "Did something go wrong?"

    If nix fails to build a kernel with an error like the following.

    ```shell
    error: builder for '/nix/store/y44r14sxadnk0pccy8ciz8p1g6wpwbzq-python3.10-pathspec-0.11.0.drv' failed with exit code 2;
           last 10 log lines:
           >   File "<frozen importlib._bootstrap>", line 1050, in _gcd_import
           >   File "<frozen importlib._bootstrap>", line 1027, in _find_and_load
           >   File "<frozen importlib._bootstrap>", line 992, in _find_and_load_unlocked
           >   File "<frozen importlib._bootstrap>", line 241, in _call_with_frames_removed
           >   File "<frozen importlib._bootstrap>", line 1050, in _gcd_import
           >   File "<frozen importlib._bootstrap>", line 1027, in _find_and_load
           >   File "<frozen importlib._bootstrap>", line 1004, in _find_and_load_unlocked
           > ModuleNotFoundError: No module named 'flit_core'
    ```

    There is some python package with a build dependency that poetry2nix is
    unaware about. To fix this you need to tell jupyenv about the dependency
    through an override. Create an `overrides.nix`.

    ```nix title="overrides.nix"
    final: prev: let
      addNativeBuildInputs = drvName: inputs: {
        "${drvName}" = prev.${drvName}.overridePythonAttrs (
          old: {
            nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
          }
        );
      };
    in
      {} // addNativeBuildInputs "pathspec" [final.flit-core]
    ```

    Note we used `"pathspec"` here as that was the package which generated the
    error and `final.flit-core` as that was the missing module.Add the override
    to your kernel.

    ```nix title="kernels.nix"
    kernel.python.python-with-numpy.overrides = overrides.nix;
    ```

    Start the jupyter environment with `nix run`.


### Julia kernel

The Julia kernel requires some stateful operations to work properly.
If you have not initialized a project yet, see the [Initialize a Project](#initialize-a-project) section.

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

    - The version of IJulia you have installed does not match what jupyenv expects.
    Check the version slug of IJulia with `ls ~/.julia/packages/IJulia/`.
    If this is different than the default value, you can override it by adding the following line to your kernel configuration.
    ``` nix
      kernel.julia.<name>.ijuliaRev = <SLUG>;
    ```

    - Your depot path is not the default.
    If your Julia packages are not installed in `"~/.julia"`, you can override it by adding the following line to your kernel configuration.
    ``` nix
      kernel.julia.<name>.julia_depot_path = <PATH>;
    ```

## Extensions

### Stateful Extensions

JupyterLab extensions can be statefully installed using the CLI or Web UI as shown in the [JupyterLab Extensions documentation][jlab-extensions].
To use the CLI, the `jupyter` binary is located in the `result` directory and can be run as follows: `./result/bin/jupyter labextension install <extension>`.

### Reproducible Extensions

TODO

[jlab-extensions]: https://jupyterlab.readthedocs.io/en/stable/user/extensions.html
