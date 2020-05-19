{ nixpkgs ? import (builtins.fetchTarball "https://github.com/GTrunSec/nixpkgs/tarball/39247f8d04c04b3ee629a1f85aeedd582bf41cac"){}
, cudapkgs ? import (builtins.fetchTarball "https://github.com/GTrunSec/nixpkgs/tarball/927fcf37933ddd24a0e16c6a45b9c0a687a40607"){}
, stdenv
, name ? "nixpkgs"
, packages ? (_:[])
, extraPackages ? (_:[])
, writeScriptBin
, runCommand
, directory
, NUM_THREADS ? 1
, cuda ? false
}:

let
  julia = nixpkgs.julia_13.overrideAttrs(oldAttrs: {checkTarget = "";});
  extraLibs = with nixpkgs;[
    mbedtls
    zeromq3
    # ImageMagick.jl
    imagemagickBig
    # GZip.jl # Required by DataFrames.jl
    gzip    
    zlib
  ] ++ (extraPackages  nixpkgs) ++ nixpkgs.lib.optionals cuda
    [
      # Flux.jl
      cudatoolkit_10_2
      cudapkgs.linuxPackages.nvidia_x11_beta
      libGLU
		  xorg.libXi xorg.libXmu freeglut
      xorg.libXext xorg.libX11 xorg.libXv xorg.libXrandr zlib
		  ncurses5
		  stdenv.cc
		  binutils
      git gitRepo gnupg autoconf curl      
      procps gnumake utillinux m4 gperf unzip
    ];

 julia_wrapped = nixpkgs.stdenv.mkDerivation rec {
    name = "julia_wrapped";
    buildInputs = [julia ] ++ extraLibs;
    nativeBuildInputs = with nixpkgs; [ makeWrapper cacert git pkgconfig which cudapkgs.linuxPackages.nvidia_x11_beta];
    phases = [ "installPhase" ];
    installPhase = ''
      export CUDA_PATH="${cudapkgs.cudatoolkit_10_2}"
      export EXTRA_LDFLAGS="-L/lib -L${cudapkgs.linuxPackages.nvidia_x11_beta}/lib"
      export EXTRA_CCFLAGS="-I/usr/include"
      export LD_LIBRARY_PATH=${nixpkgs.lib.makeLibraryPath extraLibs}
       ${if cuda then ''
      makeWrapper ${julia}/bin/julia $out/bin/julia_wrapped \
      --set JULIA_DEPOT_PATH ${directory} \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --prefix LD_LIBRARY_PATH ":" "${cudapkgs.linuxPackages.nvidia_x11_beta}/lib" \
      --set JULIA_PKGDIR ${directory} \
      --set JULIA_NUM_THREADS ${toString NUM_THREADS} \
       --set CUDA_PATH "${cudapkgs.cudatoolkit_10_2}"
      ''
         else ''
      makeWrapper ${julia}/bin/julia $out/bin/julia_wrapped \
      --set JULIA_DEPOT_PATH ${directory} \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --set JULIA_NUM_THREADS ${toString NUM_THREADS} \
      --set JULIA_PKGDIR ${directory}
         ''
        }
    '';
 };

  kernelFile = {
    display_name = "Julia - ${name}";
    language = "julia";
    argv = [
      "${julia_wrapped}/bin/julia_wrapped"
      "-i"
      "--startup-file=yes"
      "--color=yes"
      "${directory}/packages/IJulia/DrVMH/src/kernel.jl"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.png";


    env =  (if (NUM_THREADS > 1) then {
      LD_LIBRARY_PATH = "${nixpkgs.lib.makeLibraryPath extraLibs}";
      JULIA_DEPOT_PATH = "${directory}";
      JULIA_PKGDIR = "${directory}";
      JULIA_NUM_THREADS= "${toString NUM_THREADS}";
    } else
      {
        LD_LIBRARY_PATH = "${nixpkgs.lib.makeLibraryPath extraLibs}";
        JULIA_DEPOT_PATH = "${directory}";
        JULIA_PKGDIR = "${directory}";
      });
  };

  Install_JuliaCUDA = writeScriptBin "Install_Julia_CUDA" ''
  ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.add(["CUDAdrv", "CUDAnative", "CuArrays"]); using CUDAdrv, CUDAnative, CuArrays' \
    && ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.test("CUDAnative");'
  get_nvdisasm=$(dirname ${directory}/artifacts/*/bin/nvdisasm)
  rm -rf $get_nvdisasm/nvdisasm
  ln -s ${cudapkgs.cudatoolkit_10_2}/bin/nvdisasm  $get_nvdisasm/nvdisasm
  '';
  InstalliJulia = writeScriptBin "Install_iJulia" ''
     if [ ! -d "${directory}/registries/Genera/" ]; then
     mkdir -p ${directory}/registries/General && git clone https://github.com/JuliaRegistries/General.git --depth=1 ${directory}/registries/General
     fi
     ${julia_wrapped}/bin/julia_wrapped -e 'using Pkg; Pkg.add("IJulia")'
'';

  JuliaKernel = stdenv.mkDerivation {
    name = "Julia-${name}";
    src = ./julia.png;
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/julia_${name}
      cp $src $out/kernels/julia_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/julia_${name}/kernel.json
    '';
  };
in
  {
    spec = JuliaKernel;
     runtimePackages = [
      julia_wrapped
    ];
    inherit InstalliJulia julia_wrapped Install_JuliaCUDA;
  }
