{
  self,
  pkgs,
  name ? "r",
  displayName ? "R",
  rWrapper ? pkgs.rWrapper,
  rPackages ? pkgs.rPackages,
  extraRPackages ? (_: []),
}: let
  kernelEnv = rWrapper.override {
    packages = (extraRPackages rPackages) ++ [rPackages.IRkernel];
  };
in {
  inherit name displayName;
  language = "r";
  argv = [
    "${kernelEnv}/bin/R"
    "--slave"
    "-e"
    "IRkernel::main()"
    "--args"
    "{connection_file}"
  ];
  codemirrorMode = "R";
  logo64 = ./logo64.png;
}
