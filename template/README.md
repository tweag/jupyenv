# Simple JupyterLab Environment Template

## Getting started

1. Create a new project folder and `cd` into it.

```shell
$ mkdir my-project
$ cd my-project
```

2. Initialize the project with the jupyterWith flake template.

```shell
$ nix flake init --template github:tweag/jupyterWith
```

3. Kernels are located in the `kernels` directory. Kernels files that start
an underscore are disabled and will not appear in JupyterLab. Remove the
underscore from the file name to enable a kernel.

4. Start the JupyterLab environment.

```shell
$ nix run
```

5. The environment should start up with instructions on what to do next.
