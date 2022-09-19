{
  description = "Example Python Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.python {
      inherit name;
      displayName = "Example Python Kernel";
    };
}
