{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.go {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Go Kernel";
}
