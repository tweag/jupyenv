{ nixpkgsPath ? ./nix }:

with (import ./. { inherit nixpkgsPath; });

let
  pkgs = import nixpkgsPath {};

  jupyterLab = jupyterlabWith {
    kernels = with kernels; [

    ( iHaskellWith {
        name = "hvega";
        packages = p: with p; [
          hvega
          PyF
          formatting
          string-qq
        ];
      })

    ( iPythonWith {
        name = "numpy";
        packages = p: with p; [
          numpy
        ];
      })
    ];
  };

in
  pkgs.dockerTools.buildImage {
    name = "jupyterlab-ihaskell";
    tag = "latest";
    created = "now";
    contents = [ jupyterLab pkgs.glibcLocales ];
    config = {
      Env = [
           "LOCALE_ARCHIVE=${pkgs.glibcLocales}/lib/locale/locale-archive"
           "LANG=en_US.UTF-8"
           "LANGUAGE=en_US:en" 
           "LC_ALL=en_US.UTF-8"
            ];
      CMD = [ "/bin/jupyter-lab" "--ip=0.0.0.0" "--no-browser" "--allow-root" ];
      WorkingDir = "/data";
      ExposedPorts = {
        "8888" = {};
      };
      Volumes = {
        "/data" = {};
      };
    };
  }
