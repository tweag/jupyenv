{
  description = "Example Javascript Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.javascript {
      inherit name;
      displayName = "Example Javascript Kernel";
    };
}
