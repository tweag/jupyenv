{
  self,
  pkgs,
  rWrapper ? pkgs.rWrapper,
  rPackages ? pkgs.rPackages,
  extraRPackages ? (_: []),
}: let
  kernelEnv = rWrapper.override {packages = (extraRPackages rPackages) ++ [rPackages.IRkernel];};
in
  {
    name ? "r",
    displayName ? "R", # TODO: add version
    language ? "r",
    argv ? [
      "${kernelEnv}/bin/R"
      "--slave"
      "-e"
      "IRkernel::main()"
      "--args"
      "{connection_file}"
    ],
    codemirrorMode ? "R",
    logo64 ? ./logo64.png,
  }: {
    inherit
      name
      displayName
      language
      argv
      codemirrorMode
      logo64
      ;
  }
