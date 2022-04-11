# Jupyter :heart: Nix

This repository provides a Nix-based framework for the definition of
declarative and reproducible Jupyter environments. These environments
include JupyterLab - configurable with extensions - the classic notebook,
and configurable Jupyter kernels.


## Getting started


### Bootstrap your projects

```shell
$ nix flake new --template github:tweag/jupyter-nix myjupyter
$ cd myjupyter
```

<details>
  <summary>What is going on here?</summary>

  Jupyter-Nix uses templates! The previous command creates a new flake in the `myjupyter` directory using the template from the specified github repository. There will be a `README.md` in there to help you get started.

</details>

### Enable kernels

A list of available kernels in located in `./kernels/available`.

To enable any kernel, copy it from the `available` directory, up one level, to the `kernels` directory.

<details>
  <summary>Click here for an example.</summary>

  To enable an `ipython` kernel do:

  ```shell
  $ cp kernels/available/ipython.nix kernels/my-python.nix
  ```

  Notice that we gave the kernel file a new name, `my-python.nix`. You can have multiple kernels in the same project! It is recommended you give each one a descriptive file name to help you remember in the future.

</details>

### Extensions

Extensions can be added by enabling them in the `./extensions/extensions.toml` file. Each extension has an `enable` value with a default value of `false`. Change the value to `true` and that extension will be enabled.

<details>
  <summary>Click here for an example.</summary>

  If we open the `extensions.toml` previously mentioned, we would see something like the following:

  ```toml
  [some-extension]
  name = "Some Extension"
  description = "An extension that does something."
  documentation = "docs.some-extension.org"
  enable = false
  ```

  We can change the `enable` value to `true` and that extension will work.

  ```toml
  [some-extension]
  name = "Some Extension"
  description = "An extension that does something."
  documentation = "docs.some-extension.org"
  enable = true
  ```

  There will multiple extensions in the file with their own `enable` flag, so make sure to change it for each extension you want enabled.

</details>

### Start JupyterLab

Make sure you are in the top directory of your project (e.g. `myjupyter`), and run the following command.

```shell
nix run
```

Open a browser and ???

## Contributing

TODO

If you are new to contributing to open source, [this guide](https://opensource.guide/how-to-contribute/) helps explain why, what, and how to successfully get involved.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
