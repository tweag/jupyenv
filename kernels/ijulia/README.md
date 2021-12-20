# JupyterWith IJulia

the nixpkgs doesn't have a package's manager for Julia lang.
So, run command `Install_iJulia` to install `Ijulia` and initialize JULIA_PKGDIR (in your first time of running environment)  before you launch `Jupyter notbook`.

- Julia CUDA run Command `/result/bin/Install_Julia_CUDA` to install CUDA environment

the nixpkgs doesn't have an julia package manager support.
So, run command `Install_iJulia` to install `Ijulia` before you launch `Jupyter notbook`.

```nix
## for buildEnv
 paths = [
           iJulia.runtimePackages
          ];
 ##or nix-shell BuildInputs
 buildInputs = [ iJulia.runtimePackages ]
```

The IJulia kernel can be used as follows:

```nix
let
    custom-python-env = pkgs.python3.buildEnv.override
    {
      extraLibs = with pkgs.python3Packages; [ xlrd ];
      ignoreCollisions = true;
    };
  in {
  iJulia =
    let
      juliaPackages = builtins.getEnv "PRJ_ROOT" + "/packages/julia/";
    in
    jupyterWith.kernels.iJuliaWith rec {
      name = "Julia-data-env";
      #Project.toml directory
      activateDir = juliaPackages;
      # JuliaPackages directory
      JULIA_DEPOT_PATH = juliaPackages + "/julia_depot";
      extraEnv = {
        #TODO NEXT VERSION or PATCH
        #https://github.com/JuliaLang/julia/issues/40585#issuecomment-834096490
        PYTHON = "${custom-python-env}/bin/python";
      };
    };
}


```
