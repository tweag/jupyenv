{
  name,
  availableKernels,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Custom ${name}";
}
