{
  description = "Example Bash Kernel";
  kernel = {
    pkgs,
    availableKernels,
    name,
  }:
    availableKernels.bash {
      inherit name;
      displayName = "Example Bash Kernel";
    };
}
