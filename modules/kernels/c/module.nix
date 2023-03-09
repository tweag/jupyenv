{
  config,
  system,
  ...
} @ args:
import ./../../poetry.nix {
  requiredRuntimePackages = [
    config.nixpkgs.stdenv.cc
  ];
  kernelName = "c";
}
args
