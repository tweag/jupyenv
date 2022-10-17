{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.r {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example R Kernel";
}
