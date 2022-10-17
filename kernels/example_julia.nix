{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.julia {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Julia Kernel";
}
