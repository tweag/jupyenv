# JupyterWith IJulia

the nixpkgs doesn't have an julia package manager support.
So, run command `Install_iJulia` to install `Ijulia` before you launch `Jupyter notbook`.

```nix
## for buildEnv
 paths = [
           iJulia.InstalliJulia
          ];
 ##or nix-shell BuildInputs
 buildInputs = [ iJulia.InstalliJulia ]
```

The IJulia kernel can be used as follows:

```nix
{
    iJulia = jupyter.kernels.iJuliaWith {
    name =  "julia";
    ##JULIA_PKGDIR and JULIA_DEPOT_PATH which are your realpath(or in current project path).
    # EXAMPLE: echo $(realpath ./.julia_pkgs) 
    directory = "/home/gtrun/data/master-jupyter/.julia_pkgs";
    ##LD_LIBRARY_PATH that is dependence of LIBRARY's ennvironemt.(For Julia packages)
    extraPackages = p: with p;[  
    # GZip.jl # Required by DataFrames.jl
      gzip
      zlib
    ];
  };
```
