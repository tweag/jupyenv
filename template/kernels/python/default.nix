{
  name,
  availableKernels,
  extraArgs,
}:
availableKernels.python {
  name = "custom-${name}";
  inherit (extraArgs) system;
  displayName = "Custom ${name}";
}
