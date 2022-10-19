{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.javascript {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Javascript Kernel";
}
