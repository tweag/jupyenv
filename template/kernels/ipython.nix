{
  mkKernel,
  kernels,
  name,
  ...
}:
mkKernel kernels.ipython {
  displayName = name;
}
