{
  config,
  system,
  mkKernel,
  ...
} @ args:
import ./../../poetry.nix {
  inherit mkKernel;

  argvKernelName = "nix-kernel";
  codemirrorMode = "";
  language = "nix";

  requiredRuntimePackages = [
    config.nixpkgs.nix
  ];
  kernelName = "nix";
}
args
