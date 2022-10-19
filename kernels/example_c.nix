{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.c {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example C Kernel";
}
