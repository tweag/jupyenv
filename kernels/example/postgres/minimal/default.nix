{pkgs, ...}: {
  kernel.postgres.minimal = {
    enable = true;
  };
}
