{
  config,
  system,
  mkKernel,
  ...
} @ args:
import ./../../poetry.nix {
  inherit mkKernel;

  argvKernelName = "jupyter_c_kernel";
  codemirrorMode = "clike";
  language = "c";

  requiredRuntimePackages = [
    config.nixpkgs.stdenv.cc
  ];
  kernelName = "c";
}
args
