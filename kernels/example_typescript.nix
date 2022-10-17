{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.typescript {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Typescript Kernel";
}
