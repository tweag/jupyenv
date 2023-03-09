{
  config,
  system,
  ...
} @ args:
import ./../../poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.elmPackages.elm
  ];
  kernelName = "elm";
}
args
