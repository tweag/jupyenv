{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Python Kernel";
  extraPackages = ps: with ps; [requests numpy matplotlib];
}
