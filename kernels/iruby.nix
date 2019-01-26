{ bundlerApp
, python3
, stdenv
, name ? "nixpkgs"
, packages ? (_:[])
}:
let 
  iRubyEnv = bundlerApp {
      pname = "iruby";
      gemdir = ./iruby;
      exes = [ "iruby" ];
    };

  pythonEnv = python3.withPackages (p: with p; [ jupyter ipykernel ] );

  kernelFile = {
    display_name = "IRuby - ${name}";
    language = "ruby";
    argv = [
      "${iRubyEnv}/bin/iruby"
      "kernel"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.png";
  };

  irubyKernel = stdenv.mkDerivation {
    name = "iruby-${name}";
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/iruby_${name}
      echo '${builtins.toJSON kernelFile}' > $out/kernels/iruby_${name}/kernel.json
    '';
  };
in
  irubyKernel
