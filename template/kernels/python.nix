{
  name,
  availableKernels,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Custom ${name}";
  extraPackages = ps: with ps; [numpy matplotlib];
}
