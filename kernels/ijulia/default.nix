{ pkgs
, stdenv
, name ? "nixpkgs"
, extraEnv ? { }
, packages ? (_: [ ])
, extraPackages ? (_: [ ])
, writeScriptBin
, JULIA_DEPOT_PATH ? "~/.julia"
, activateDir ? ""
}:
let
  startupFile = pkgs.writeText "startup.jl" ''
    import Pkg
    Pkg.activate("${activateDir}")
    Pkg.instantiate()
  '';
  kernelFile = {
    display_name = "Julia - ${name}";
    language = "julia";
    argv = [
      "${pkgs.julia_16-bin}/bin/julia"
      "-L"
      "${startupFile}"
      "-i"
      "--startup-file=yes"
      "--color=yes"
      "${JULIA_DEPOT_PATH}/packages/IJulia/e8kqU/src/kernel.jl"
      "{connection_file}"
    ];

    logo64 = "logo-64x64.png";

    env = {
      JULIA_PKGDIR = JULIA_DEPOT_PATH;
    } // extraEnv;
  };

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
    pkgs.julia_16-bin
  ];
}
