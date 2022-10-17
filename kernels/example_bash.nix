{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.bash {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Bash Kernel";
}
