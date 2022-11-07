{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.zsh {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Zsh Kernel";
}
