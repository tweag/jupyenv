{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.typescript {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Typescript Kernel";
}
