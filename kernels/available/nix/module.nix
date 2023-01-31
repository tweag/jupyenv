{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.legacyPackages.${system}.nix
  ];
  kernelName = "nix";
}
args
