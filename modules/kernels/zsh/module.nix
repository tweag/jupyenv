{
  config,
  system,
  ...
} @ args:
import ./../../poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.zsh
    config.nixpkgs.coreutils
  ];
  kernelName = "zsh";
}
args
