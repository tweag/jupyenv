{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.haskell {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Haskell Kernel";
}
