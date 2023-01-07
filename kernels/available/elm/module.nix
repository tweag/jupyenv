{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.legacyPackages.${system}.elmPackages.elm
  ];
  kernelName = "elm";
}
args
