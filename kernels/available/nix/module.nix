{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.nix
  ];
  kernelName = "nix";
}
args
