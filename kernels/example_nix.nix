{
  description = "Example Nix Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.nix {
      inherit name;
      displayName = "Example Nix Kernel";
    };
}
