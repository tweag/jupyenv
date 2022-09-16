{
  pkgs,
  availableKernels,
  kernelName,
}:
availableKernels.python {
  name = "custom-${kernelName}"; # must be unique
  displayName = "custom ${kernelName}";
}
