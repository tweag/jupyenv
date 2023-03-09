{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.elmPackages.elm
  ];
  kernelName = "elm";
}
args
