{
  stdenv,
  lib,
  callPackage,
  nodePackages,
  writeScriptBin,
  name ? "default",
}: let
  iJavascriptEnv = nodePackages.ijavascript;

  iJavascriptSh = writeScriptBin "ijavascript" ''
    #! ${stdenv.shell}
    export PATH="${lib.makeBinPath [iJavascriptEnv]}:$PATH"
    ${iJavascriptEnv}/bin/ijskernel "$@"
  '';

  kernelFile = {
    display_name =
      "Javascript"
      + (
        if name == ""
        then ""
        else " - ${name}"
      );
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
    phases = "installPhase";
    installPhase = ''
      mkdir -p $out/kernels/ijavascript_${name}
      cp $src $out/kernels/ijavascript_${name}/logo-64x64.png
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ijavascript_${name}/kernel.json
    '';
  };
in {
  spec = iJavascriptKernel;
  runtimePackages = [];
}
