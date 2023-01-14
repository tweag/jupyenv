## Basics

### Initialize a Project

When you want to create a new project, make a project directory (e.g. `my-project`) and `cd` into it.
Run the following command.

```shell
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

Extensions are currently being worked on to be reproducible.
