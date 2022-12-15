{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.bash {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Bash Kernel";
}
