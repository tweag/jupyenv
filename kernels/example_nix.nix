{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.nix {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example Nix Kernel";
}
