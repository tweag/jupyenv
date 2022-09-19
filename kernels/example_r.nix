{
  description = "Example R Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.r {
      inherit name;
      displayName = "Example R Kernel";
    };
}
