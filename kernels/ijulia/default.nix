{
  pkgs,
  stdenv,
  name ? "nixpkgs",
  extraEnv ? {},
  packages ? (_: []),
  extraPackages ? (_: []),
  writeScriptBin,
  JULIA_DEPOT_PATH ? "~/.julia",
  activateDir ? "",
  rev ? "e8kqU",
  package ? pkgs.julia_16-bin,
}: let
  startupFile = pkgs.writeText "startup.jl" ''
    import Pkg
    Pkg.activate("${activateDir}")
    Pkg.update()
    Pkg.instantiate()
  '';
  activateJuliaPkg = writeScriptBin "activateJuliaPkg" ''
    export JULIA_DEPOT_PATH=${JULIA_DEPOT_PATH}
    julia -L ${startupFile} -e 'println("Initializating DONE")'
  '';
  juliaStartup = writeScriptBin "juliaStartup" ''
    julia -L ${startupFile}
  '';
  kernelFile = {
    display_name =
      "Julia"
      + (
        if name == ""
        then ""
        else " - ${name}"
      );
    language = "julia";
    argv = [
      "${package}/bin/julia"
      "-L"
      "${startupFile}"
      "-i"
      "--startup-file=yes"
      "--color=yes"
      "${JULIA_DEPOT_PATH}/packages/IJulia/${rev}/src/kernel.jl"
      "{connection_file}"
    ];

    logo64 = "logo-64x64.png";

    env =
      {
        JULIA_PKGDIR = JULIA_DEPOT_PATH;
      }
      // extraEnv;
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
in {
  spec = JuliaKernel;
  runtimePackages = [
    package
    activateJuliaPkg
    juliaStartup
  ];
}
