{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.nix {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Nix Kernel";
}
