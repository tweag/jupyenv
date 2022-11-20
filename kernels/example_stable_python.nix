{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.python {
  inherit name;
  inherit (extraArgs) system;
  pkgs = extraArgs.pkgs_stable;
  displayName = "Example (nixpkgs stable) Python Kernel";
}
