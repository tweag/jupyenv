{
  description = "Example Elm Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.elm {
      inherit name;
      displayName = "Example Elm Kernel";
    };
}
