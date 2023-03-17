{
  config,
  system,
  mkKernel,
  ...
} @ args:
import ./../../poetry.nix {
  inherit mkKernel;

  argvKernelName = "elm_kernel";
  codemirrorMode = "elm";
  language = "elm";

  requiredRuntimePackages = [
    config.nixpkgs.elmPackages.elm
  ];
  kernelName = "elm";
}
args
