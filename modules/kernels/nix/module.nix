{
  config,
  system,
  ...
} @ args:
import ./../../poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.nix
  ];
  kernelName = "nix";
}
args
