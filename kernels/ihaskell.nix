{ writeScriptBin
, haskellPackages
, stdenv
, extraIHaskellFlags ? ""
, name ? "nixpkgs"
, packages ? (_:[])
}:

let
  ihaskellEnv = haskellPackages.ghcWithPackages (self: [ self.ihaskell ] ++ packages self);

  ihaskellSh = writeScriptBin "ihaskell" ''
    #! ${stdenv.shell}
    export GHC_PACKAGE_PATH="$(echo ${ihaskellEnv}/lib/*/package.conf.d| tr ' ' ':'):$GHC_PACKAGE_PATH"
    export PATH="${stdenv.lib.makeBinPath ([ ihaskellEnv ])}:$PATH"
    ${ihaskellEnv}/bin/ihaskell ${extraIHaskellFlags} -l $(${ihaskellEnv}/bin/ghc --print-libdir) "$@"'';

  kernelFile = {
    display_name = "Haskell - " + name;
    language = "haskell";
    argv = [
      "${ihaskellSh}/bin/ihaskell"
      "kernel"
      "{connection_file}"
      "+RTS"
      "-M3g"
      "-N2"
      "-RTS"
    ];
    logo64 = "logo-64x64.svg";
  };

  ihaskellKernel = stdenv.mkDerivation {
    name = "ihaskell-kernel";
    phases = "installPhase";
    src = ./haskell.svg;
    buildInputs = [ ihaskellEnv ];
    installPhase = ''
      mkdir -p $out/kernels/ihaskell_${name}
      cp $src $out/kernels/ihaskell_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/ihaskell_${name}/kernel.json
    '';
  };
in
  ihaskellKernel
