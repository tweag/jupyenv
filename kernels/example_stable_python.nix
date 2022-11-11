{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  pkgs = extraArgs.pkgs_stable;
  displayName = "Example (nixpkgs stable) Python Kernel";
  extraPackages = ps: with ps; [requests numpy matplotlib];
}
