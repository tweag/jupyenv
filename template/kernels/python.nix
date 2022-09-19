{
  pkgs,
  availableKernels,
  kernelName,
}:
availableKernels.python.override {
  name = "custom-${kernelName}"; # must be unique
  displayName = "custom ${kernelName}";
}
