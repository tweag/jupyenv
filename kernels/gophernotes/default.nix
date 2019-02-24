{ writeScriptBin
, stdenv
, buildGoPackage 
, fetchFromGitHub
, zeromq
, pkgconfig
, name ? "nixpkgs"
, packages ? (_:[])
}:

let
    gophernotes = buildGoPackage rec {
        name = "gophernotes-${version}";
        version = "1.0.0";
      
        goPackagePath = "github.com/gopherdata/gophernotes";
      
        src = fetchFromGitHub {
          owner = "gopherdata";
          repo = "gophernotes";
          rev = "3e31b9592d59cdd8ee38436edbf16fcee9e60258";
          sha256 = "00xfa0n3vkgssjqzz2f1aaf7x2y48s92s6nnjpj34zmj4nv5pgi5";
        };

        buildInputs = [ zeromq pkgconfig ];
      
        goDeps = ./deps.nix;
      
        buildFlags = "--tags release";
      };

  gophernotesSh = writeScriptBin "gophernotes" ''
    #! ${stdenv.shell}
    export PATH="${stdenv.lib.makeBinPath ([ gophernotes ])}:$PATH"
    ${gophernotes}/bin/gophernotes "$@"'';

  kernelFile = {
    display_name = "Go - " + name;
    language = "go";
    argv = [
      "${gophernotesSh}/bin/gophernotes"
      "{connection_file}"
    ];
    logo64 = "logo-64x64.svg";
  };

  gophernotesKernel = stdenv.mkDerivation {
    name = "gophernotes";
    phases = "installPhase";
    src = ./gophernotes.png;
    buildInputs = [ gophernotes ];
    installPhase = ''
      mkdir -p $out/kernels/gophernotes_${name}
      cp $src $out/kernels/gophernotes_${name}/logo-64x64.svg
      echo '${builtins.toJSON kernelFile}' > $out/kernels/gophernotes_${name}/kernel.json
    '';
  };
in
  {
    spec = gophernotesKernel;
    runtimePackages = [];
  }
