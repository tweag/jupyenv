_: pkgs:
let
  packageOverrides = selfPythonPackages: pythonPackages: {

    jupyterlab = pythonPackages.jupyterlab.overridePythonAttrs (_:{
      doCheck = false;
    });

    nbconvert = pythonPackages.nbconvert.overridePythonAttrs (_:{
      doCheck = false;
    });

    jupyter_contrib_core = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_contrib_core";
      version = "0.3.3";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e65bc0e932ff31801003cef160a4665f2812efe26a53801925a634735e9a5794";
      };
      doCheck = false;  # too much
      propagatedBuildInputs = [
        pythonPackages.traitlets
        pythonPackages.notebook
        pythonPackages.tornado
        ];
    };

    jupyter_nbextensions_configurator = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_nbextensions_configurator";
      version = "0.4.1";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e5e86b5d9d898e1ffb30ebb08e4ad8696999f798fef3ff3262d7b999076e4e83";
      };

      propagatedBuildInputs = [
        selfPythonPackages.jupyter_contrib_core
        pythonPackages.pyyaml
        ];

      doCheck = false;  # too much
    };

    umaplearn = pythonPackages.buildPythonPackage rec {
      pname = "umap-learn";
      version = "0.3.7";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "9c81c9cdc46cc8a87adf1972eeac5ec69bbe9cec440c0e4995fc68a015aafeb9";
      };

      propagatedBuildInputs = with pythonPackages; [
        numpy
        scipy
        numba
        scikitlearn
        ];

      doCheck = false;  # too much
    };

    jupyter_c_kernel = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_c_kernel";
      version = "1.2.2";
      doCheck = false;

      src = pythonPackages.fetchPypi {
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

    ansible-kernel = pythonPackages.buildPythonPackage rec {
      pname = "ansible-kernel";
      version = "0.9.0";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "0dkncg2chv562i2fg47ic6p2h8rz739jlvii6m24y3scfahkk455";
      };

      propagatedBuildInputs = [
        pythonPackages.ipywidgets
        pythonPackages.six
        pythonPackages.docopt
        pythonPackages.tqdm
        pythonPackages.jupyter
        pythonPackages.psutil
        pythonPackages.pyyaml
        selfPythonPackages.ansible
        selfPythonPackages.ansible-runner
      ];

      postPatch = ''
       touch LICENSE.md
       # remove custom install
       sed -i "s/cmdclass={'install': Installer},//" setup.py
      '';

      doCheck = false;

      meta = with pkgs.stdenv.lib; {
        description = "An Ansible kernel for Jupyter";
        homepage = https://github.com/ansible/ansible-jupyter-kernel;
        license = licenses.asl20;
      };
    };

    ansible-runner = pythonPackages.buildPythonPackage rec {
      pname = "ansible-runner";
      version = "1.1.2";

      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "2376b39c7b4749e17e15a21844e37164d6df964c9f35f27aa679c0707b1f7b19";
      };

      checkInputs = [ pythonPackages.pytest pythonPackages.mock pythonPackages.python ];

      propagatedBuildInputs = [
        pythonPackages.six
        pythonPackages.pyyaml
        pythonPackages.python-daemon
        pythonPackages.pexpect
        pythonPackages.psutil
        ];

      checkPhase = ''
        pytest test
      '';

      # tests fail due to python location during test
      doCheck = false;

      meta = with pkgs.stdenv.lib; {
        description = "Stable and consistent interface abstraction to Ansible";
        homepage = https://github.com/ansible/ansible-runner;
        license = licenses.asl20;
      };
    };

    ansible = pythonPackages.buildPythonPackage rec {

      pname = "ansible";
      version = "2.7.5";

      outputs = [ "out" "man" ];

      src = pkgs.fetchurl {
        url = "https://releases.ansible.com/ansible/${pname}-${version}.tar.gz";
        sha256 = "1fsif2jmkrrgiawsd8r6sxrqvh01fvrmdhas0p540a6i9fby3yda";
      };

      prePatch = ''
        sed -i "s,/usr/,$out," lib/ansible/constants.py
      '';

      postInstall = ''
        wrapPythonProgramsIn "$out/bin" "$out $PYTHONPATH"
        for m in docs/man/man1/*; do
          install -vD $m -t $man/share/man/man1
        done
      '';

      doCheck = false;
      dontStrip = true;
      dontPatchELF = true;
      dontPatchShebangs = false;

      propagatedBuildInputs = with pythonPackages; [
        pycrypto paramiko jinja2 pyyaml httplib2 boto six netaddr dnspython jmespath dopy
      ];

      meta = with pkgs.stdenv.lib; {
        homepage = http://www.ansible.com;
        description = "A simple automation tool";
        license = with licenses; [ gpl3 ];
      };

    };

    rsa = pythonPackages.rsa.overridePythonAttrs (oldAttrs: {
      preConfigure =  ''
        substituteInPlace setup.py --replace "open('README.md')" "open('README.md',encoding='utf-8')"
        '';
    });

    # Performance tests failing on different computers
    pathpy = pythonPackages.pathpy.overridePythonAttrs (_:{
      doCheck = false;
    });

  };

in

{
  python3 = pkgs.python3.override (old: {
    packageOverrides =
      pkgs.lib.composeExtensions
        (old.packageOverrides or (_: _: {}))
        packageOverrides;
  });
}
