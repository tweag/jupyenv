{
  mkPoetryKernel,
  config,
  ...
}: {
  imports = [
    (mkPoetryKernel {
      argvKernelName = "zsh_jupyter_kernel";
      codemirrorMode = "shell";
      language = "zsh";
      requiredRuntimePackages = [
        config.nixpkgs.zsh
        config.nixpkgs.coreutils
      ];
      kernelName = "zsh";
    })
  ];
}
