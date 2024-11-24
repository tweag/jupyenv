{mkPoetryKernel, ...}: {
  imports = [
    (
      mkPoetryKernel {
        argvKernelName = "ipykernel_launcher";
        codemirrorMode = "python";
        language = "python";
        kernelName = "python";
      }
    )
  ];
}
