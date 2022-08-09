{
  mkKernel,
  kernels,
  name,
  ...
}:
mkKernel kernels.julia {
  displayName = name;
}
