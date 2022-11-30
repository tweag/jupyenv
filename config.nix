{pkgs, ...}: {
  runtimePackages = with pkgs; [ruby];

  kernel.python.example = {
    enable = true;
  };
}
