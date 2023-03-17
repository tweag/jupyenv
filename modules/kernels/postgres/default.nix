{
  config,
  system,
  mkKernel,
  ...
} @ args:
import ./../../poetry.nix {
  inherit mkKernel;

  argvKernelName = "postgres_kernel";
  codemirrorMode = "pgsql";
  language = "postgres";

  kernelName = "postgres";
}
args
