# JupyterWith IJulia

the nixpkgs doesn't have a package's manager for Julia lang.
So, run command `Install_iJulia` to install `Ijulia` and initialize JULIA_PKGDIR (in your first time of running environment)  before you launch `Jupyter notbook`.

- Julia CUDA run Command `/result/bin/Install_Julia_CUDA` to install CUDA environment
```nix
## for buildEnv
 paths = [
           iJulia.InstalliJulia
           julia_wrapped
           iJulia.Install_JuliaCUDA
          ];
 ##or nix-shell BuildInputs
 buildInputs = [ iJulia.InstalliJulia julia_wrapped iJulia.Install_JuliaCUDA
 ]
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
    # enabke multi-threads
    NUM_THREADS = 8;
    ##  enable CUDA support (for Flux.jl package)
    cuda = true;
};
```
