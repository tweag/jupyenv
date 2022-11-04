# Jupyter :heart: Nix

<p float="left">
  <img src="img/logos/bash-logo64.png" width="45" />
  <img src="img/logos/c-logo64.png" width="45" />
  <img src="img/logos/elm-logo64.png" width="45" />
  <img src="img/logos/go-logo64.png" width="45" />
  <img src="img/logos/haskell-logo64.png" width="45" />
  <img src="img/logos/python-logo64.png" width="45" />
  <img src="img/logos/javascript-logo64.png" width="45" />
  <img src="img/logos/julia-logo64.png" width="45" />
  <img src="img/logos/nix-logo64.png" width="45" />
  <img src="img/logos/ocaml-logo64.png" width="45" />
  <img src="img/logos/postgres-logo64.png" width="45" />
  <img src="img/logos/r-logo64.png" width="45" />
  <img src="img/logos/rust-logo64.png" width="45" />
  <img src="img/logos/scala-logo64.png" width="45" />
  <img src="img/logos/typescript-logo64.png" width="45" />
  <img src="img/logos/zsh-logo64.png" width="45" />
</p>

jupyterWith provides a Nix-based framework for the definition of declarative and reproducible Jupyter environments.
These environments include JupyterLab - configurable with extensions - the classic notebook, and configurable Jupyter kernels.

## Getting started

The following snippet will create a new project directory, initialize the project with a flake template, enable a Python kernel, and start the JupyterLab environment.

```shell
mkdir my-project
cd my-project
nix flake init --template github:tweag/jupyterWith
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

For further instructions about the environment, kernels, and extensions, see the [How To](HOWTO.md) and [Tutorials](TUTORIALS.md).

See [References](DETAILS.md) for information about how jupyterWith is architected.
