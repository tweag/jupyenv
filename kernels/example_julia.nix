{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.julia {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Julia Kernel";
}
