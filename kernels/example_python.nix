{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Python Kernel";
}
