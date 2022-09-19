{
  description = "Example Typescript Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.typescript {
      inherit name;
      displayName = "Example Typescript Kernel";
    };
}
