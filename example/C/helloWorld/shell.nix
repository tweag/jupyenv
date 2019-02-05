let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {};

  jupyterlabWithKernels = jupyter.jupyterlabWith {
      kernels = [ (jupyter.kernels.cKernel {name="basic";}) ];
  };
in
  jupyterlabWithKernels.env
