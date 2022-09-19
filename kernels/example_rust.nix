{
  description = "Example Rust Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.rust {
      inherit name;
      displayName = "Example Rust Kernel";
    };
}
