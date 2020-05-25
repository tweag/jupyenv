{ writeScriptBin
, stdenv
, buildGoModule
, fetchFromGitHub
, name ? "nixpkgs"
}:

let
  gophernotes = buildGoModule rec {
      name = "gophernotes-${version}";
      version = "0.7.0";

      src = fetchFromGitHub {
        owner = "gopherdata";
        repo = "gophernotes";
        rev = "7bdc956a8aceb1ebf3e7a92417aabbe05a6f9f95";
        sha256 = "00fx5z7zp5yzj8dw9v02b1d1pg07pmrhp7gxkhg5xcndbdd1isgs";
      };

      vendorSha256 = "1fn8ayld039p1j5xgrk5a9y72ssks20p10bdac4nill4rqmw7cxk";
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
