{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.legacyPackages.${system}.zsh
    config.nixpkgs.legacyPackages.${system}.coreutils
  ];
  kernelName = "zsh";
}
args
