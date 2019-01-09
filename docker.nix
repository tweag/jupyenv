{ nixpkgsPath ? ./nix }:

with (import ./. { inherit nixpkgsPath; });

let
  pkgs = import nixpkgsPath {};

  jupyterLab = jupyterlabRunner {
    kernels = with kernels; [
    # Sample Haskell kernel
    ( haskellWith {
        name = "sample";
        packages = p: with p; [
          hvega
          PyF
          formatting
          string-qq
        ];
      })

    # Sample Python kernel
    ( pythonWith {
        name = "sample";
        packages = p: with p; [
          numpy
        ];
      })
    ];

    directory = import ./generate-directory.nix {
      extensions = [
        "jupyterlab-ihaskell"
        "jupyterlab_bokeh"
        "@jupyterlab/toc"
        "qgrid"
      ];
    };
  };

in
  pkgs.dockerTools.buildImage {
    name = "jupyterlab";
    tag = "latest";
    created = "now";
    contents = jupyterLab;
    config = {
      Entrypoint = [ "/bin/jupyter-lab" "--ip=0.0.0.0" "--no-browser" "--allow-root" ];
      WorkingDir = "/data";
      ExposedPorts = {
        "8888" = {};
      };
      Volumes = {
        "/data" = {};
      };
    };
  }
