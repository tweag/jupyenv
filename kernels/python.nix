{ python3
, pythonPackages
, stdenv
, packages ? (_:[])
}:

let
  python = python3.withPackages (p:
    packages p ++ [ p.ipykernel ]
  );

  kernelFile = {
    displayName = "Python 3";
    language = "python";
    argv = [
      "${python.interpreter}"
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
      mkdir -p $out
      cp $src $out/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernel.json
    '';
  };
in
  ipythonKernel
