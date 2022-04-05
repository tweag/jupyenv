# Jupyter ❤️ Nix

This repository provides a Nix-based framework for the definition of
declarative and reproducible Jupyter environments. These environments
include JupyterLab - configurable with extensions - the classic notebook,
and configurable Jupyter kernels.


## Getting started


```
{
  inputs.flake-utils.url = "...";
  inputs.nixpkgs.url = "...";
  inputs.jupyter.url = "...";

  outputs = { self, nixpkgs, jupyter }:
    flake-utils.lib.eachDefaultSystem (system: let
       pkgs = import nixpkgs { inherit system; };

       # customize mkJupyterLab function via .override
       mkJupyterLab = jupyter.lib.mkJupyterLab.override {
          poertryLock = ./custom/poetry.lock;
          kernels = k: [];
          extensions = e: e ++ []
       };

       # create jupyter instance (
       jupyterInstance = mkJupyterLab {        
         inherit pkgs;

         # list confiured kernels
         kernels = [
           (jupyter.lib.mkPythonKernel {
             inherit pkgs;
             displayName = "My python kernel";
             directory = ./python-env/;
           });
         };

         # list extensions to enable for jupyter
         extensions = e: [
           e.jupy-ext
          ];
       };
    in
    { packages.default = jupyterInstance; })
}
```


## Contributing

TODO

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE)
file for details.
