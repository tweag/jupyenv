{pkgs, ...}: {
  kernel.python.projectdir-example = {
    enable = true;
    projectDir = ./mykernel;
    preferWheels = true; # Pillow fails to build :(
  };
}
