{
  config,
  system,
  mkKernel,
  ...
} @ args:
import ./../../poetry.nix {
  inherit mkKernel;

  argvKernelName = "ipykernel_launcher";
  codemirrorMode = "python";
  language = "python";

  kernelName = "python";
}
args
