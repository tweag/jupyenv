{
  pkgs,
  availableKernels,
  name,
}:
availableKernels.python {
  displayName = name;
}
