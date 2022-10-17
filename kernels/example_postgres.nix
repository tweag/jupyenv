{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.postgres {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Postgres Kernel";
}
