{
  mkPoetryKernel,
  config,
  ...
}: {
  imports = [
    (mkPoetryKernel {
      argvKernelName = "elm_kernel";
      codemirrorMode = "elm";
      language = "elm";
      requiredRuntimePackages = [
        config.nixpkgs.elmPackages.elm
      ];
      kernelName = "elm";
    })
  ];
}
