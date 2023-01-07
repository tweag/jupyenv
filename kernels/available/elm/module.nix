{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.legacyPackages.${system}.elm
  ];
  kernelName = "elm";
}
args
