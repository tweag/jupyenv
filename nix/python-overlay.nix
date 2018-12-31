_: pkgs:
let
    jupyter_contrib_core = pkgs.python36Packages.buildPythonPackage rec {
      pname = "jupyter_contrib_core";
      version = "0.3.3";
    
      src = pkgs.python36.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "e65bc0e932ff31801003cef160a4665f2812efe26a53801925a634735e9a5794";
      };
      doCheck = false;  # too much
      propagatedBuildInputs = [
        pkgs.python36Packages.traitlets
        pkgs.python36Packages.notebook
        ];
    };

    jupyter_nbextensions_configurator = pkgs.python36Packages.buildPythonPackage rec {
      pname = "jupyter_nbextensions_configurator";
      version = "0.4.1";
    
      src = pkgs.python36.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "e5e86b5d9d898e1ffb30ebb08e4ad8696999f798fef3ff3262d7b999076e4e83";
      };

      propagatedBuildInputs = [
        jupyter_contrib_core
        pkgs.python36Packages.pyyaml
        ];

      doCheck = false;  # too much
    };
in
{
  python36 = pkgs.python36.override {
    packageOverrides = _: pythonPackages:
    {
      jupyter_contrib_core=jupyter_contrib_core;
      jupyter_nbextensions_configurator=jupyter_nbextensions_configurator;
    };
  };
}
