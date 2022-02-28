final: prev: let
  packageOverrides = selfPythonPackages: pythonPackages: {
    notebook = pythonPackages.notebook.overridePythonAttrs (
      oldAttrs:
        {
          postFixup = ''
            wrapProgram $out/bin/jupyter-notebook --add-flags '--KernelSpecManager.ensure_native_kernel=False'
          '';
        }
        // (prev.lib.optionalAttrs prev.stdenv.isDarwin {
          doCheck = false;
        })
    );

    nbclassic = pythonPackages.nbclassic.overridePythonAttrs (oldAttrs: {
      postFixup = ''
        wrapProgram $out/bin/jupyter-nbclassic --add-flags '--KernelSpecManager.ensure_native_kernel=False'
      '';
    });

    jupyter_server = pythonPackages.jupyter_server.overridePythonAttrs (
      oldAttrs:
        prev.lib.optionalAttrs prev.stdenv.isDarwin {
          doCheck = false;
        }
    );

    send2trash = pythonPackages.send2trash.overridePythonAttrs (
      _: (prev.lib.optionalAttrs prev.stdenv.isDarwin {
        version = "1.8";
        doCheck = false;
        src = prev.fetchFromGitHub
        {
          owner = "arsenetar";
          repo = "send2trash";
          rev = "484913ba0f024caf0fdac462f9b608d2b06d7c38";
          sha256 = "sha256-HZeN/kpisPRrVwg1xGGUjxspztZKRbacGY5gpa537cw=";
        };
        preConfigure = ''
          sed -i  's|find_library("Foundation")|"/System/Library/Frameworks/Foundation.framework/Versions/C/Resources/BridgeSupport/Foundation.dylib"|g' send2trash/plat_osx_ctypes.py
        '';
      })
    );

    jupyterlab = pythonPackages.jupyterlab.overridePythonAttrs (oldAttrs: {
      postFixup = ''
        wrapProgram $out/bin/jupyter-lab --add-flags '--KernelSpecManager.ensure_native_kernel=False'
      '';
      doCheck = false;
    });

    jupyter_contrib_core = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_contrib_core";
      version = "0.3.3";
      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e65bc0e932ff31801003cef160a4665f2812efe26a53801925a634735e9a5794";
      };
      propagatedBuildInputs = [
        pythonPackages.traitlets
        selfPythonPackages.notebook
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
    };

    jupyter_c_kernel = pythonPackages.buildPythonPackage rec {
      pname = "jupyter_c_kernel";
      version = "1.2.2";
      doCheck = false;
      src = pythonPackages.fetchPypi {
        inherit pname version;
        sha256 = "e4b34235b42761cfc3ff08386675b2362e5a97fb926c135eee782661db08a140";
      };
      meta = with prev.lib; {
        description = "Minimalistic C kernel for Jupyter";
        homepage = https://github.com/brendanrius/jupyter-c-kernel/;
        license = licenses.mit;
        maintainers = [];
      };
    };
  };
in {
  python3 = prev.python3.override (old: {
    packageOverrides =
      prev.lib.composeExtensions
      (old.packageOverrides or (_: _: {}))
      packageOverrides;
  });
}
