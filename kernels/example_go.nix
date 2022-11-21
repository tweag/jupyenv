{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.go {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Go Kernel";
}
