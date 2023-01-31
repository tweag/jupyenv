{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  kernelName = "bash";
  requiredRuntimePackages = [
    config.nixpkgs.legacyPackages.${system}.bashInteractive
    config.nixpkgs.legacyPackages.${system}.coreutils
  ];
}
args
