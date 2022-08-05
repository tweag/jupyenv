{
  self,
  pkgs,
  julia-bin ? pkgs.julia_17-bin,
}: let
  inherit (pkgs) fetchFromGitHub;

  ijuliaVer = "1.23.3";
  ijuliaSrc = fetchFromGitHub {
    owner = "JuliaLang";
    repo = "IJulia.jl";
    rev = "v${ijuliaVer}";
    sha256 = "sha256-GdiYmq0IJoRqiMBRL/z3UW4Nlu41ylvaASvoE7/jQyk=";
  };
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
        "${julia-bin}/bin/julia"
        "-i"
        "--startup-file=no"
        "--color=yes"
        "${ijuliaSrc}/src/kernel.jl"
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
