{
  self,
  pkgs ? import <nixpkgs> {},
  name ? "ocaml",
  displayName ? "OCaml",
  runtimePackages ? [],
  extraRuntimePackages ? [],
  ocamlPackages ? pkgs.ocaml-ng.ocamlPackages_4_10,
  #  ocamlPackages ? pkgs.ocamlPackages,
  ocamlBuildInputs ?
    with ocamlPackages; [
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
    ],
  ocamlPropagatedBuildInputs ?
    with ocamlPackages; [
      bigstringaf
      result
    ],
}: let
  inherit (pkgs) fetchFromGitHub;

  OcamlKernel = ocamlPackages.buildDunePackage rec {
    pname = "jupyter";
    version = "2.7.5"; # TODO: upgrade this to 2.8.0
    useDune2 = true;

    minimalOCamlVersion = "4.04";

    src = fetchFromGitHub {
      owner = "akabe";
      repo = "ocaml-jupyter";
      rev = "v${version}";
      sha256 = "0dayyhvw3ynvncy9b7daiz3bcybfh38mbivgr693i16ld3gp6c6v";
    };

    buildInputs = ocamlBuildInputs;
    propagatedBuildInputs = ocamlPropagatedBuildInputs;

    doCheck = false;

    meta = with pkgs.lib; {
      homepage = "https://github.com/akabe/ocaml-jupyter";
      description = "An OCaml kernel for Jupyter (IPython) notebook.";
      license = licenses.mit;
      maintainers = with lib.maintainers; [akabe];
    };
  };

  allRuntimePackages = runtimePackages ++ extraRuntimePackages ++ ocamlBuildInputs;

  env = OcamlKernel;
  wrappedEnv =
    pkgs.runCommand "wrapper-${env.name}"
    {nativeBuildInputs = [pkgs.makeWrapper];}
    ''
      mkdir -p $out/bin
      for i in ${env}/bin/*; do
        filename=$(basename $i)
        ln -s ${env}/bin/$filename $out/bin/$filename
        wrapProgram $out/bin/$filename \
          --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
      done
    '';
in {
  inherit name displayName;
  language = "ocaml";
  argv = [
    "${wrappedEnv}/bin/ocaml-jupyter-kernel"
    "-init"
    "/home/$USER/.ocamlinit"
    "--merlin"
    "${pkgs.ocamlPackages.merlin}/bin/ocamlmerlin"
    "--verbosity"
    "app"
    "--connection-file"
    "{connection_file}"
  ];
  codemirrorMode = "ocaml";
  logo64 = ./logo64.png;
}
