# Jupyter :heart: Nix

<p float="left">
  <img src="kernels/ansible/logo64.png" width="100" />
  <img src="kernels/bash/logo64.png" width="100" />
  <img src="kernels/c/logo64.png" width="100" />
  <img src="kernels/cpp/logo64.png" width="100" />
  <img src="kernels/elm/logo64.png" width="100" />
  <img src="kernels/go/logo64.png" width="100" />
  <img src="kernels/ihaskell/logo64.png" width="100" />
  <img src="kernels/ipython/logo64.png" width="100" />
  <img src="kernels/javascript/logo64.png" width="100" />
  <img src="kernels/julia/logo64.png" width="100" />
  <img src="kernels/nix/logo64.png" width="100" />
  <img src="kernels/ocaml/logo64.png" width="100" />
  <img src="kernels/r/logo64.png" width="100" />
  <img src="kernels/ruby/logo64.png" width="100" />
  <img src="kernels/rust/logo64.png" width="100" />
</p>


This repository provides a Nix-based framework for the definition of
declarative and reproducible Jupyter environments. These environments
include JupyterLab - configurable with extensions - the classic notebook,
and configurable Jupyter kernels.


## Getting started


### Bootstrap your projects

Create a new project folder and `cd` into it.

```shell
$ mkdir my-project
$ cd my-project
```

JupyterWith uses templates! Initialize your project with the jupyterWith template. There will be a `README.md` in there to help you get started.

```shell
$ nix flake init --template github:tweag/jupyterWith
```

### Enable kernels

Your new project should ahve a `kernels` directory which contains all the kernels. Any kernels prefixed with an underscore is disabled. To enable any kernel, rename it so it no longer has an underscore prefix.

```shell
$ cp kernels/_ipython.nix kernels/my-ipython.nix
```

Notice that we gave the kernel file a new name, `my-ipython.nix`. You can have multiple kernels in the same project! We recommend you give each one a descriptive file name to help you remember in the future.

### Extensions

Extensions are currently being worked on to be reproducible.

### Start JupyterLab

Make sure you are in the top directory of your project (e.g. `my-project`), and run the following command.

```shell
nix run
```

The environment should start up with instructions on what to do next.

## Contributing

PRs are welcome! This project provides a development shell which you can enter with `nix develop`. Please run `pre-commit run -all` before submitting your pull request for review. This will run a nix formatter for consistency.

If you are new to contributing to open source, [this guide](https://opensource.guide/how-to-contribute/) helps explain why, what, and how to successfully get involved.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
