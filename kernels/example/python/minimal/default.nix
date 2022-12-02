{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Python Kernel";
}
