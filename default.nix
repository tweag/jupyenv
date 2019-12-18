{ overlays ? []
, config ? {}
, pkgs ? import ./nix { inherit config overlays; }
}:

let
  # Kernel generators.
  kernels = pkgs.callPackage ./kernels {};

  # Python version setup.
  python3 = pkgs.python3Packages;

  # Default configuration.
  defaultDirectory = "${python3.jupyterlab}/share/jupyter/lab";
  defaultKernels = [ (kernels.iPythonWith {}) ];
  defaultExtraPackages = p: [];

  # Import the main package components.
  mkBase = pkgs.callPackage ./lib/base.nix {};

  # JupyterLab with the appropriate kernel and directory setup.
  jupyterlabWith = {
    directory ? defaultDirectory,
    kernels ? defaultKernels,
    extraPackages ? defaultExtraPackages
  }:
    let
      base = mkBase { inherit directory kernels extraPackages; };
    in
      base.jupyterlab;

  # JupyterLab with the appropriate kernel and directory setup.
  serviceWith = {
    directory ? defaultDirectory,
    kernels ? defaultKernels,
    extraPackages ? defaultExtraPackages
  }:
    let
      base = mkBase { inherit directory kernels extraPackages; };
    in
      import ./lib/service.nix {
        inherit directory kernels extraPackages;
        jupyterlab = base.jupyterlab;
        environment = base.environment;
        path = base.path;
      };
in

{
  inherit jupyterlabWith serviceWith kernels;
  mkDirectoryWith = pkgs.callPackage ./lib/directory.nix {};
  mkDockerImage = pkgs.callPackage ./lib/docker.nix {};
}
