{ 
  writeText,
  ocamlPackages,
  fetchFromGitHub,
  name ? "nixpkgs",
  packages ? [],
  pkgs
}:

let 
  pkgs = import <nixpkgs> {};
  kernelSpecFile = pkgs.writeText "kernel.json" (builtins.toJSON {
    argv = [
    "{out-path}/bin/ocaml-jupyter-kernel" 
    "-init"
    "/home/$USER/.ocamlinit"
    "--merlin"
    "{merlin-path}/bin/ocamlmerlin"
    "--verbosity"
    "app"
    "--connection-file"
    "{connection_file}"
    ];
    display_name = "OCaml - ${name}";
    language = "OCaml";
  });
  OcamlKernel = ocamlPackages.buildDunePackage rec {
  pname = "jupyter";
  version = "2.7.5";
  useDune2 = true;

  minimalOCamlVersion = "4.04";

  src = fetchFromGitHub {
    owner  = "akabe";
    repo   = "ocaml-jupyter";
    rev    = "v${version}";
    sha256 = "0dayyhvw3ynvncy9b7daiz3bcybfh38mbivgr693i16ld3gp6c6v";
  };

  #checkInputs = [ alcotest ppx_let ];
  buildInputs = with ocamlPackages; [ 
    ocaml-syntax-shims 
    yojson 
    lwt_ppx
    ppx_deriving
    ppx_deriving_yojson
    base64
    uuidm
    logs
    cryptokit
    zmq
    zmq-lwt
    cppo
    ounit
    merlin
  ];
  propagatedBuildInputs = with ocamlPackages; [ bigstringaf result ];

  doCheck = false;

  postInstall = ''
    export kerneldir=$out/kernels/ocaml_${pkgs.ocaml.version}
    mkdir -p $kerneldir
    substitute ${kernelSpecFile} $kerneldir/kernel.json \
    --replace "{merlin-path}" ${pkgs.ocamlPackages.merlin} \
    --replace "{out-path}" $out 
    '';

  meta = with pkgs.lib; {
    homepage = "https://github.com/akabe/ocaml-jupyter";
    description = "An OCaml kernel for Jupyter (IPython) notebook.";
    license = licenses.mit;
    maintainers = with lib.maintainers; [ akabe ];
  };
};
in 
{
  spec = OcamlKernel;
  runtimePackages = (with pkgs; packages) ++ OcamlKernel.buildInputs;
}