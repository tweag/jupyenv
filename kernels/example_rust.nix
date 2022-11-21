{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.rust {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example Rust Kernel";
}
