{
  stdenv,
  python3,
  bash,
  name ? "nixpkgs",
}: let
  kernelEnv =
    (
      python3.withPackages
      (p: [p.bash_kernel p.ipykernel p.pexpect])
    )
    .override (args: {ignoreCollisions = true;});

  kernelFile = {
    argv = [
      "${kernelEnv.interpreter}"
      "-m"
      "bash_kernel"
      "-f"
      "{connection_file}"
    ];
    codemirror_mode = "shell";
    display_name =
      "Bash"
      + (if name == ""
      then ""
      else " - ${name}");
    language = "bash";
    logo64 = "logo-64x64.svg";
  };

  bashKernel = stdenv.mkDerivation {
    name = "bash-kernel";
    phases = "installPhase";
    src = ./bash.png;
    buildInputs = [];
    installPhase = ''
      mkdir -p $out/kernels/bash_${name}
      cp $src $out/kernels/bash_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/bash_${name}/kernel.json
    '';
  };
in {
  spec = bashKernel;
  runtimePackages = [bash];
}
