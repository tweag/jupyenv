_: pkgs:
let
    jupyter_contrib_core = pkgs.python3Packages.buildPythonPackage rec {
      pname = "jupyter_contrib_core";
      version = "0.3.3";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "e65bc0e932ff31801003cef160a4665f2812efe26a53801925a634735e9a5794";
      };
      doCheck = false;  # too much
      propagatedBuildInputs = [
        pkgs.python3Packages.traitlets
        pkgs.python3Packages.notebook
        pkgs.python3Packages.tornado
        ];
    };

    jupyter_nbextensions_configurator = pkgs.python3Packages.buildPythonPackage rec {
      pname = "jupyter_nbextensions_configurator";
      version = "0.4.1";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "e5e86b5d9d898e1ffb30ebb08e4ad8696999f798fef3ff3262d7b999076e4e83";
      };

      propagatedBuildInputs = [
        jupyter_contrib_core
        pkgs.python3Packages.pyyaml
        ];

      doCheck = false;  # too much
    };

    umaplearn = pkgs.python3Packages.buildPythonPackage rec {
      pname = "umap-learn";
      version = "0.3.7";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "9c81c9cdc46cc8a87adf1972eeac5ec69bbe9cec440c0e4995fc68a015aafeb9";
      };

      propagatedBuildInputs = with pkgs.python3Packages; [
        numpy
        scipy
        numba
        scikitlearn
        ];

      doCheck = false;  # too much
    };

    jupyter_c_kernel = pkgs.python3Packages.buildPythonPackage rec {
      pname = "jupyter_c_kernel";
      version = "1.2.2";
      doCheck = false;

      src = pkgs.python3Packages.fetchPypi {
        inherit pname version;
        sha256 = "e4b34235b42761cfc3ff08386675b2362e5a97fb926c135eee782661db08a140";
      };

      meta = with pkgs.stdenv.lib; {
        description = "Minimalistic C kernel for Jupyter";
        homepage = https://github.com/brendanrius/jupyter-c-kernel/;
        license = licenses.mit;
        maintainers = [];
      };
    };

in
{
  python3 = pkgs.python3.override {
    packageOverrides = _: pythonPackages:
    {
      inherit
        umaplearn
        jupyter_contrib_core
        jupyter_nbextensions_configurator
        jupyter_c_kernel;

      rsa = pythonPackages.rsa.overridePythonAttrs (oldAttrs: {
        preConfigure =  ''
          substituteInPlace setup.py --replace "open('README.md')" "open('README.md',encoding='utf-8')"
          '';
       });

      pathpy = pythonPackages.pathpy.overridePythonAttrs (_:{
        doCheck = false;
      });
    };
  };
}
