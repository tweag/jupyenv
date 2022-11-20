{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.c {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example C Kernel";
}
