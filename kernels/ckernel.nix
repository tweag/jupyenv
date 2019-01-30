{ stdenv
, python3
, name ? "nixpkgs"
, packages ? []
}:

let
  jupyterCKernel = python3.pkgs.buildPythonPackage rec {
    pname = "jupyter_c_kernel";
    version = "1.2.2";
    doCheck = false;

    src = python3.pkgs.fetchPypi {
      inherit pname version;
      sha256 = "e4b34235b42761cfc3ff08386675b2362e5a97fb926c135eee782661db08a140";
    };

    meta = with stdenv.lib; {
      description = "Minimalistic C kernel for Jupyter";
      homepage = https://github.com/brendanrius/jupyter-c-kernel/;
      license = licenses.mit;
      maintainers = [];
    };
  };

  kernelEnv = python3.withPackages (p: [ p.jupyterCKernel ]);

  kernelFile = {
    argv = [
      "${kernelEnv.interpreter}"
      "-m"
      "jupyter_c_kernel"
      "-f"
      "{connection_file}"
    ];
    display_name = "C - " + name;
    language = "c";
    logo64 = "logo-64x64.svg";
  };

  cKernel = stdenv.mkDerivation {
    name = "c-kernel";
    phases = "installPhase";
    src = ./c.png;
    buildInputs = [];
    installPhase = ''
      mkdir -p $out/kernels/c_${name}
      cp $src $out/kernels/c_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/c_${name}/kernel.json
    '';
  };
in
  cKernel
