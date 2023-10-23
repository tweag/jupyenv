# Jupyter :heart: Nix

<p float="left">
  <a href="https://jupyenv.io/documentation/options/#kernel-bash"><img src="modules/kernels/bash/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-c"><img src="modules/kernels/c/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-elm"><img src="modules/kernels/elm/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-go"><img src="modules/kernels/go/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-haskell"><img src="modules/kernels/haskell/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-python"><img src="modules/kernels/python/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-javascript"><img src="modules/kernels/javascript/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-julia"><img src="modules/kernels/julia/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-nix"><img src="modules/kernels/nix/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-ocaml"><img src="modules/kernels/ocaml/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-postgres"><img src="modules/kernels/postgres/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-r"><img src="modules/kernels/r/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-rust"><img src="modules/kernels/rust/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-scala"><img src="modules/kernels/scala/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-typescript"><img src="modules/kernels/typescript/logo64.png" width="45" /></a>
  <a href="https://jupyenv.io/documentation/options/#kernel-zsh"><img src="modules/kernels/zsh/logo64.png" width="45" /></a>
</p>

This repository provides a Nix-based framework for the definition of
declarative and reproducible Jupyter environments. These environments
include JupyterLab - configurable with extensions - the classic notebook,
and configurable Jupyter kernels.

## Getting started

The following snippet will create a new project directory, initialize the project with a flake template, enable a Python kernel, and start the JupyterLab environment.

```shell
mkdir my-project
cd my-project
nix flake init --template github:tweag/jupyenv
nix run
```

After some time, you should see the following in your terminal. Your default web browser should open and enter the JupyterLab environment. If it does not, use one of the suggested URLs.

```shell
...
[I 2022-10-11 18:47:30.346 ServerApp] Jupyter Server 1.17.1 is running at:
[I 2022-10-11 18:47:30.346 ServerApp] http://localhost:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
[I 2022-10-11 18:47:30.346 ServerApp]  or http://127.0.0.1:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
[I 2022-10-11 18:47:30.346 ServerApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 2022-10-11 18:47:30.359 ServerApp] 
    
    To access the server, open this file in a browser:
        file:///home/bakerdn/.local/share/jupyter/runtime/jpserver-286971-open.html
    Or copy and paste one of these URLs:
        http://localhost:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
     or http://127.0.0.1:8888/lab?token=8f2261a45601848bd79eda97d8d39c3d0f4978bc61fbe346
```

## Documentation

See the [website](https://jupyenv.io/) for further instructions about the environment, kernels, and extensions.

## Contributing

PRs are welcome!

This project provides a development shell which you can enter with `nix develop`. Please run `pre-commit run -all` before submitting your pull request for review. This will run a nix formatter for consistency.

If you are new to contributing to open source, [this guide](https://opensource.guide/how-to-contribute/) helps explain why, what, and how to successfully get involved.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE.md) file for details.
