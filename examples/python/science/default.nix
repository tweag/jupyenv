{pkgs, ...}: {
  kernel.python.science-example = {
    enable = true;
    extraPackages = ps: [
      ps.numpy
      ps.scipy
      # issue with matplotlib
      # ps.matplotlib
    ];
  };
}
