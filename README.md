# Jupyter :heart: Nix

<p float="left">
  <img src="modules/kernels/bash/logo-64x64.png" width="45" />
  <img src="modules/kernels/c/logo-64x64.png" width="45" />
  <img src="modules/kernels/elm/logo-64x64.png" width="45" />
  <img src="modules/kernels/go/logo-64x64.png" width="45" />
  <img src="modules/kernels/haskell/logo-64x64.png" width="45" />
  <img src="modules/kernels/python/logo-64x64.png" width="45" />
  <img src="modules/kernels/javascript/logo-64x64.png" width="45" />
  <img src="modules/kernels/julia/logo-64x64.png" width="45" />
  <img src="modules/kernels/nix/logo-64x64.png" width="45" />
  <img src="modules/kernels/ocaml/logo-64x64.png" width="45" />
  <img src="modules/kernels/postgres/logo-64x64.png" width="45" />
  <img src="modules/kernels/r/logo-64x64.png" width="45" />
  <img src="modules/kernels/rust/logo-64x64.png" width="45" />
  <img src="modules/kernels/scala/logo-64x64.png" width="45" />
  <img src="modules/kernels/typescript/logo-64x64.png" width="45" />
  <img src="modules/kernels/zsh/logo-64x64.png" width="45" />
  <img src="modules/kernels/dotnet/logo-64x64.png" width="45" />
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
