{
  config,
  system,
  ...
} @ args:
import ./../../poetry.nix {
  kernelName = "bash";
  requiredRuntimePackages = [
    config.nixpkgs.bashInteractive
    config.nixpkgs.coreutils
  ];
}
args
