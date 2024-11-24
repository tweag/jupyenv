{
  mkPoetryKernel,
  config,
  ...
}: {
  imports = [
    (mkPoetryKernel {
      argvKernelName = "bash_kernel";
      codemirrorMode = "shell";
      language = "bash";
      kernelName = "bash";
      requiredRuntimePackages = [
        config.nixpkgs.bashInteractive
        config.nixpkgs.coreutils
      ];
    })
  ];
}
