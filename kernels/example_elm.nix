{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.elm {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Elm Kernel";
}
