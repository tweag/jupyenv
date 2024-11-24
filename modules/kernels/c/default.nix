{
  mkPoetryKernel,
  config,
  ...
}: {
  imports = [
    (mkPoetryKernel {
      argvKernelName = "jupyter_c_kernel";
      codemirrorMode = "clike";
      language = "c";
      requiredRuntimePackages = [
        config.nixpkgs.stdenv.cc
      ];
      kernelName = "c";
    })
  ];
}
