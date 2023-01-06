{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "r",
  displayName ? "R",
  runtimePackages ? [],
  rWrapper ? pkgs.rWrapper,
  rPackages ? pkgs.rPackages,
  extraRPackages ? (_: []),
}: let
  env = rWrapper.override {
    packages = (extraRPackages rPackages) ++ [rPackages.IRkernel];
  };

  allRuntimePackages = runtimePackages;

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
  language = "r";
  argv = [
    "${wrappedEnv}/bin/R"
    "--slave"
    "-e"
    "IRkernel::main()"
    "--args"
    "{connection_file}"
  ];
  codemirrorMode = "R";
  logo64 = ./logo64.png;
}
