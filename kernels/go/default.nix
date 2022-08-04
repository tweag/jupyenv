{
  self,
  pkgs,
  gophernotes ? pkgs.gophernotes,
}: let
  inherit (pkgs) lib stdenv writeScriptBin;

  gophernotesSh = writeScriptBin "gophernotes" ''
    #! ${stdenv.shell}
    export PATH="${lib.makeBinPath [gophernotes]}:$PATH"
    ${gophernotes}/bin/gophernotes "$@"'';
in
  {
    name ? "go",
    displayName ? "Go", # TODO: add version
    language ? "go",
    argv ? null,
    codemirrorMode ? "go",
    logo64 ? ./logo64.png,
    runtimePackages ? with pkgs; [go],
    extraRuntimePackages ? [],
  }: let
    allRuntimePackages = runtimePackages ++ extraRuntimePackages;

    env = gophernotesSh;
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
        "${wrappedEnv}/bin/gophernotes"
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
