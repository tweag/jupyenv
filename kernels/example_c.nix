{
  description = "Example C Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.c {
      inherit name;
      displayName = "Example C Kernel";
    };
}
