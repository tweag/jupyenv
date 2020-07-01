let
  jupyterLibPath = ../../..;
  jupyter = import jupyterLibPath {};

  jupyterlabWithKernels = jupyter.jupyterlabWith {
      kernels = [ (jupyter.kernels.rust {}) ];
  };
in
  jupyterlabWithKernels.env
