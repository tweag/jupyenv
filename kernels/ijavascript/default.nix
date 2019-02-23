{nodejs-6_x
,stdenv
,python2
,utillinux
,runCommand
,writeTextFile
,fetchurl
,fetchgit
,writeScriptBin
,name?"default"
}:

let
  nodejs = nodejs-6_x;

  nodeEnv = import ./node-env.nix {
    inherit nodejs stdenv python2 utillinux runCommand writeTextFile;
    libtool = null;
  };

  iJavascriptEnv = (import ./node-packages.nix {inherit nodeEnv fetchurl fetchgit;}).ijavascript;

  iJavascriptSh = writeScriptBin "ijavascript" ''
    #! ${stdenv.shell}
    export PATH="${stdenv.lib.makeBinPath ([ iJavascriptEnv ])}:$PATH"
    ${iJavascriptEnv}/bin/ijskernel "$@"'';

  kernelFile = {
    display_name = "Javascript - " + name;
    language = "javascript";
    argv = [
      "${iJavascriptSh}/bin/ijavascript"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.png";
  };

  iJavascriptKernel = stdenv.mkDerivation {
    name = "ijavascript-kernel";
    src = ./javascript.png;
    buildInputs = [ iJavascriptEnv ];
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/ijavascript_${name}
      cp $src $out/kernels/ijavascript_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ijavascript_${name}/kernel.json
    '';
  };
in
  {
    spec = iJavascriptKernel;
    runtimePackages = [];
  }
