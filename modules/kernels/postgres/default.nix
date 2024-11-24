{
  mkPoetryKernel,
  config,
  ...
}: {
  imports = [
    (mkPoetryKernel {
      argvKernelName = "postgres_kernel";
      codemirrorMode = "pgsql";
      language = "postgres";
      kernelName = "postgres";
    })
  ];
}
