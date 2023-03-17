{
  config,
  system,
  mkKernel,
  ...
} @ args:
import ./../../poetry.nix {
  inherit mkKernel;

  argvKernelName = "bash_kernel";
  codemirrorMode = "shell";
  language = "bash";

  kernelName = "bash";
  requiredRuntimePackages = [
    config.nixpkgs.bashInteractive
    config.nixpkgs.coreutils
  ];
}
args
