{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.scala {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Scala Kernel";
}
