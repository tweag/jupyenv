{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "ocaml",
  displayName ? "OCaml",
  runtimePackages ? [],
  extraRuntimePackages ? [],
  ocamlPackages ? pkgs.ocaml-ng.ocamlPackages_4_12,
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
  # allRuntimePackages = runtimePackages ++ extraRuntimePackages ++ ocamlBuildInputs;
  allRuntimePackages = runtimePackages ++ extraRuntimePackages;

  OcamlKernel = let
    name = "jupyter";
    version = "2.7.5"; # TODO: upgrade this to 2.8.0. Need to have ppx_yojson_conv in nixpkgs first; not ppx_yojson_conv_lib.
    src = pkgs.fetchFromGitHub {
      owner = "akabe";
      repo = "ocaml-jupyter";
      rev = "v${version}";
      sha256 = "0dayyhvw3ynvncy9b7daiz3bcybfh38mbivgr693i16ld3gp6c6v";
    };
  in
    pkgs.opam-nix.buildDuneProject {inherit pkgs;} name src {};

  # OcamlKernel = ocamlPackages.buildDunePackage rec {
  #   pname = "jupyter";
  #   version = "2.7.5"; # TODO: upgrade this to 2.8.0. Need to have ppx_yojson_conv in nixpkgs first; not ppx_yojson_conv_lib.
  #   duneVersion = "3";

  #   minimalOCamlVersion = "4.04";

  #   src = pkgs.fetchFromGitHub {
  #     owner = "akabe";
  #     repo = "ocaml-jupyter";
  #     rev = "v${version}";
  #     sha256 = "0dayyhvw3ynvncy9b7daiz3bcybfh38mbivgr693i16ld3gp6c6v";
  #   };

  #   buildInputs = ocamlBuildInputs;
  #   propagatedBuildInputs = ocamlPropagatedBuildInputs;

  #   doCheck = false;

  #   meta = with pkgs.lib; {
  #     homepage = "https://github.com/akabe/ocaml-jupyter";
  #     description = "An OCaml kernel for Jupyter (IPython) notebook.";
  #     license = licenses.mit;
  #     maintainers = with lib.maintainers; [akabe];
  #   };
  # };

  env = pkgs.callPackage OcamlKernel.jupyter {};
  wrappedEnv = let
    ocamlVersion = ocamlPackages.ocaml.version;
  in
    pkgs.runCommand "wrapper-ocaml-kernel"
    {nativeBuildInputs = [pkgs.makeWrapper];}
    ''
      mkdir -p $out/bin
      for i in ${env}/bin/*; do
        filename=$(basename $i)
        # XXX: 'CAML_LD_LIBRARY_PATH' should be set automatically by the kernel.
        # Not sure why it doesn't, but setting it manually seems to fix things
        # makeWrapper ${env}/bin/$filename $out/bin/$filename \
        #   --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}" \
        #   --set CAML_LD_LIBRARY_PATH "${pkgs.lib.makeSearchPath "lib/ocaml/${ocamlVersion}/site-lib/stublibs" ocamlPropagatedBuildInputs}"
        makeWrapper ${env}/bin/$filename $out/bin/$filename \
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
