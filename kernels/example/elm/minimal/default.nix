{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.elm {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Elm Kernel";
}
