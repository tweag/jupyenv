{
  description = "Example Postgres Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.postgres {
      inherit name;
      displayName = "Example Postgres Kernel";
    };
}
