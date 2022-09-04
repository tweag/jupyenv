{
  pkgs,
  availableKernels,
  name,
}:
availableKernels.ipython {
  displayName = name;
}
