{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.r {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example R Kernel";
}
