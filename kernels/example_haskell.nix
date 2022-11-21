{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.haskell {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Haskell Kernel";
}
