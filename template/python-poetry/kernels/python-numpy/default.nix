{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  projectDir = ./.;
  displayName = "Python with Poetry Numpy";
  name = "python-with-poetry-numpy";
}
