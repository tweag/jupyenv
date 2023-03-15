{
  config,
  system,
  mkKernel,
  ...
} @ args:
import ./../../poetry.nix {
  kernelName = "bash";
  requiredRuntimePackages = [
    config.nixpkgs.bashInteractive
    config.nixpkgs.coreutils
  ];
  inherit mkKernel;
}
args
