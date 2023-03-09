# Roadmap

## Immediate Work

- [ ] Internal

    - [ ] Refactor jupyenv internals.
    - [ ] Make `nixpkgs` configurable per kernel.

- [ ] Documentation

    - [ ] Add more examples that execise all the kernel arguments.
    - [ ] Add example configurations to the site.

## Future work

- [ ] MacOS

    - [ ] Better support.
    - [ ] Document what does not work, #144.

- [ ] Kernels

    - [ ] [Add F# kernel](https://github.com/tweag/jupyenv/issues/393)
    - [ ] [Add Scheme kernel](https://github.com/tweag/jupyenv/issues/441)
    - [ ] See [this list](https://github.com/tweag/jupyenv/issues/79#issuecomment-670774373).

- [ ] Docker

    - [ ] Build docker image with all extensions and kernels in CI.

- [ ] Declarative JupyterLab extensions with Nix

    - [ ] See last comments in issue #31 for possible implementations.
    - [ ] Establish Jupyter extensions to be shipped by default, #72.
    - [ ] iHaskell built-in auto-completion functionality, #141.

- [ ] JupyterHub

    - [ ] Add support; see comments in issue #69.
    - [ ] Provide NixOS module; see issue #79.
