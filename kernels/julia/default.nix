{
  self,
  pkgs,
  julia-bin ? pkgs.julia_17-bin,
  JULIA_DEPOT_PATH ? "~/.julia",
  activateDir ? "",
  ijuliaRev ? "AQu2H",
}: let
  inherit (pkgs) writeScriptBin writeText;
  startupFile = writeText "startup.jl" ''
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
in
  {
    name ? "julia",
    displayName ? "Julia", # TODO: add version
    language ? "julia",
    argv ? null,
    codemirrorMode ? "julia",
    logo64 ? ./logo64.png,
    runtimePackages ? [],
    extraRuntimePackages ? [],
  }: let
    allRuntimePackages = runtimePackages ++ extraRuntimePackages;

    env = julia-bin;
    wrappedEnv =
      pkgs.runCommand "wrapper-${env.name}"
      {nativeBuildInputs = [pkgs.makeWrapper];}
      ''
        mkdir -p $out/bin
        for i in ${env}/bin/*; do
          filename=$(basename $i)
          ln -s ${env}/bin/$filename $out/bin/$filename
          wrapProgram $out/bin/$filename \
            --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
        done
      '';

    argv_ =
      if argv == null
      then [
        "${wrappedEnv}/bin/julia"
        "-L"
        "${startupFile}"
        "-i"
        "--startup-file=yes"
        "--color=yes"
        "${JULIA_DEPOT_PATH}/packages/IJulia/${ijuliaRev}/src/kernel.jl"
        "{connection_file}"
      ]
      else argv;
  in {
    argv = argv_;
    inherit
      name
      displayName
      language
      codemirrorMode
      logo64
      ;
  }
