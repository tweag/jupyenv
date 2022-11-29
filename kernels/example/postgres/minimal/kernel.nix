{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.postgres {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Postgres Kernel";
}
