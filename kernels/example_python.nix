{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Python Kernel";
  extraPackages = ps: [ps.numpy ps.matplotlib];
}
