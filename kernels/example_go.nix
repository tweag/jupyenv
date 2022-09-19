{
  description = "Example Go Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.go {
      inherit name;
      displayName = "Example Go Kernel";
    };
}
