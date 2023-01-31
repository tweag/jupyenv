{
  config,
  system,
  ...
} @ args:
import ./../../../modules/poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.legacyPackages.${system}.stdenv.cc
  ];
  kernelName = "c";
}
args
