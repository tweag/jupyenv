{pkgs, ...}: {
  kernel.python.minimal-example = {
    enable = true;
    extraPackages = ps: [ps.numpy ps.scipy ps.matplotlib];
  };
}
