{
  self,
  pkgs,
  cling ? pkgs.cling,
}: let
  inherit (pkgs) lib stdenv writeScriptBin;

  xeusCling = import ./xeusCling.nix {inherit pkgs cling;};

  xeusClingSh = writeScriptBin "xeusCling" ''
    #! ${stdenv.shell}
    export PATH="${lib.makeBinPath [xeusCling]}:$PATH"
    ${xeusCling}/bin/xeus-cling "$@"'';
in
  {
    name ? "cpp",
    displayName ? "C++", # TODO: add version
    language ? "cpp",
    argv ? null,
    codemirrorMode ? "c++",
    logo64 ? ./logo64.png,
    runtimePackages ? [],
    extraRuntimePackages ? [],
  }: let
    allRuntimePackages = runtimePackages ++ extraRuntimePackages;

    env = xeusClingSh;
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
        "${xeusClingSh}/bin/xeusCling"
        "-f"
        "{connection_file}"
        "-std=c++11"
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
