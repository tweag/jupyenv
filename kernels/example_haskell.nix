{
  description = "Example Haskell Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.haskell {
      inherit name;
      displayName = "Example Haskell Kernel";
    };
}
