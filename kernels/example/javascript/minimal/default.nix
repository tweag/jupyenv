{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.javascript {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Javascript Kernel";
}
