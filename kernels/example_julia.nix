{
  description = "Example Julia Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.julia {
      inherit name;
      displayName = "Example Julia Kernel";
    };
}
