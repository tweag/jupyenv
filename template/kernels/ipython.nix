{pkgs}:
pkgs.jupyterWith.kernels.iPythonWith {
  name = "Python-data-env";
  ignoreCollisions = true;
  packages = p: [
    p.numpy
  ];
}
