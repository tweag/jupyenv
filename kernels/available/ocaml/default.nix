{
  self,
  pkgs,
  name ? "ocaml",
  displayName ? "OCaml",
  runtimePackages ? [],
  extraRuntimePackages ? [],
  ocamlPackages ? pkgs.ocaml-ng.ocamlPackages_4_10,
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
      lwt
      stdint
      zmq
      zarith
      cryptokit
    ],
}: let
  allRuntimePackages = runtimePackages ++ extraRuntimePackages ++ ocamlBuildInputs;

  OcamlKernel = ocamlPackages.buildDunePackage rec {
    pname = "jupyter";
    version = "2.7.5"; # TODO: upgrade this to 2.8.0
    useDune2 = true;

    minimalOCamlVersion = "4.04";

    src = pkgs.fetchFromGitHub {
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

  env = OcamlKernel;
  wrappedEnv =
    pkgs.runCommand "wrapper-${env.name}"
    {nativeBuildInputs = [pkgs.makeWrapper];}
    ''
      mkdir -p $out/bin
      for i in ${env}/bin/*; do
        filename=$(basename $i)
        makeWrapper ${env}/bin/$filename $out/bin/$filename \
          --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}" \
          --set CAML_LD_LIBRARY_PATH "${pkgs.lib.makeSearchPath "lib/ocaml/4.10.2/site-lib/stublibs" ocamlPropagatedBuildInputs}"
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
