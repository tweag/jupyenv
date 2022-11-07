{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.scala {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Scala Kernel";
}
