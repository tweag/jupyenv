{
  self,
  pkgs,
  name ? "ruby",
  displayName ? "Ruby",
  runtimePackages ? with pkgs; [czmq zeromq],
  extraRuntimePackages ? [],
  iruby ? pkgs.iruby,
  extraRubyPackages ? [],
}: let
  allRuntimePackages = runtimePackages ++ extraRuntimePackages;

  env = iruby;
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
  language = "ruby";
  argv = [
    "${wrappedEnv}/bin/iruby"
    "kernel"
    "{connection_file}"
  ];
  codemirrorMode = "ruby";
  logo64 = ./logo64.png;
}
