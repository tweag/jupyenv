{
  pkgs,
  name,
  displayName,
  requiredRuntimePackages,
  runtimePackages,
  gophernotes,
}: let
  inherit (pkgs) lib stdenv writeScriptBin;

  gophernotesSh = writeScriptBin "gophernotes" ''
    #! ${stdenv.shell}
    export PATH="${lib.makeBinPath [gophernotes]}:$PATH"
    ${gophernotes}/bin/gophernotes "$@"'';

  allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

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
in {
  inherit name displayName;
  language = "go";
  argv = [
    "${wrappedEnv}/bin/gophernotes"
    "{connection_file}"
  ];
  codemirrorMode = "go";
  logo64 = ./logo64.png;
}
