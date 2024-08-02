{pkgs, ...}: {
  kernel.python.minimal = {
    enable = true;
    python = "python310";
  };

  kernel.rust.minimal = {
    enable = true;
  };
}
