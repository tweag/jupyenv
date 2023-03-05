{
  pkgs,
  name,
  displayName,
  requiredRuntimePackages,
  runtimePackages,
  ignoreCollisions,
  poetryEnv,
}: let
  env = poetryEnv.override (args: {inherit ignoreCollisions;});

  allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

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
  language = "c";
  argv = [
    "${wrappedEnv}/bin/python"
    "-m"
    "jupyter_c_kernel"
    "-f"
    "{connection_file}"
  ];
  codemirrorMode = "clike";
  logo64 = ./logo64.png;
}
