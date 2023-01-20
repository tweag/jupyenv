{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Python Kernel";
  extraPackages = ps: [ps.numpy ps.scipy ps.matplotlib];
}
