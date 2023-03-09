{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  kernelName = "bash";
  requiredRuntimePackages = [
    config.nixpkgs.bashInteractive
    config.nixpkgs.coreutils
  ];
}
args
