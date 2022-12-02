{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.zsh {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Zsh Kernel";
}
