{pkgs, ...}: {
  kernel.python.science-example = {
    enable = true;
    env = pkgs.python3.withPackages (ps:
      with ps; [
        ps.ipykernel
        ps.scipy
        ps.matplotlib
      ]);
  };
}
