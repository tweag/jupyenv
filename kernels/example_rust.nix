{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.rust {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Rust Kernel";
}
