{ nixpkgs ? import (builtins.fetchTarball "https://github.com/GTrunSec/nixpkgs/tarball/39247f8d04c04b3ee629a1f85aeedd582bf41cac"){}
, stdenv
, name ? "nixpkgs"
, packages ? (_:[])
, extraPackages ? (_:[])
, writeScriptBin
, runCommand
, directory
, NUM_THREADS ? 8
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
    git gitRepo gnupg autoconf curl
    procps gnumake utillinux m4 gperf unzip
  ] ++ (extraPackages  nixpkgs);

 julia_wrapped = nixpkgs.runCommand "julia_wrapped" {
    name = "julia_wrapped";
    buildInputs = [julia nixpkgs.makeWrapper] ++ extraLibs;
    propagatedBuildInputs = [julia];
 }
    ''
      mkdir -p $out/bin
      export LD_LIBRARY_PATH=${nixpkgs.lib.makeLibraryPath extraLibs}
      makeWrapper ${julia}/bin/julia $out/bin/julia_wrapped \
      --set JULIA_DEPOT_PATH ${directory} \
      --prefix LD_LIBRARY_PATH : "$LD_LIBRARY_PATH" \
      --set JULIA_PKGDIR ${directory}
    '';

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

    env = {
      LD_LIBRARY_PATH = "${nixpkgs.lib.makeLibraryPath extraLibs}";
      JULIA_DEPOT_PATH = "${directory}";
      JULIA_PKGDIR = "${directory}";
    };
  };


  InstalliJulia = writeScriptBin "Install_iJulia" ''
     export JULIA_PKGDIR=${directory}
     export JULIA_DEPOT_PATH=${directory}
     export JULIA_NUM_THREADS=8
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
    inherit InstalliJulia;
  }
