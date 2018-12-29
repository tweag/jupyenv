{ python36
, stdenv
, packages ? (_:[])
}:

let
  kernelEnv = python36.withPackages (p:
    packages p ++ (with p; [
      ipykernel
      numpy
      scipy
    ])
  );

  kernelFile = {
    display_name = "Python 3 - data";
    language = "python";
    argv = [
      "${kernelEnv.interpreter}"
      "-m"
      "ipykernel_launcher"
      "-f"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.png";
  };

  ipythonKernel = stdenv.mkDerivation {
    name = "ipython-kernel";
    src = ./python.png;
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/ipython
      cp $src $out/kernels/ipython/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ipython/kernel.json
    '';
  };
in
  ipythonKernel 
