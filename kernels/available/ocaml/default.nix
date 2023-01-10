{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "ocaml",
  displayName ? "OCaml",
  requiredRuntimePackages ? [],
  runtimePackages ? [],
  # https://github.com/tweag/opam-nix
  opam-nix ? self.inputs.opam-nix,
  # Set of required packages
  requiredOcamlPackages ? {merlin = "*";},
  # Set of user desired packages
  ocamlPackages ? {}, # { hex = "*"; owl = "*"; },
  # List of directories containing .opam files
  opamProjects ? [], # [ self.inputs.myOpamProject ],
  # See opam-nix.buildDuneProject first argument
  opamNixArgs ? {},
}: let
  allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

  _opam-nix = opam-nix.lib.${system};

  customOpamRepo = _opam-nix.joinRepos (map _opam-nix.makeOpamRepo opamProjects);
  customOpamPackages = __mapAttrs (_: pkgs.lib.last) (_opam-nix.listRepo customOpamRepo);

  userOcamlPackages = ocamlPackages // customOpamPackages;
  allOcamlPackages = requiredOcamlPackages // userOcamlPackages;

  scope = let
    name = "jupyter";
    version = "2.8.0";
    src = pkgs.fetchFromGitHub {
      owner = "akabe";
      repo = "ocaml-jupyter";
      rev = "v${version}";
      sha256 = "sha256-IWbM6rOjcE1QHO+GVl8ZwiZQpNmdBbTdfMZe69D5lIU=";
    };
  in
    _opam-nix.buildDuneProject
    ({
        pkgs = pkgs.extend (final: _: {zeromq3 = final.zeromq4;});
        repos = [_opam-nix.opamRepository customOpamRepo];
      }
      // opamNixArgs)
    name
    src
    allOcamlPackages;

  # Derivations corresponding to the user-requested ocaml package dependencies.
  ocamlPackageDerivations = __attrValues (pkgs.lib.getAttrs (__attrNames userOcamlPackages) scope);
  # A derivation which represents all our runtime dependencies.
  # It cannot be built, but its `inputDerivation` can.
  # The said `inputDerivation` will set all the required environment variables.
  runtimeEnv = pkgs.mkShell {
    name = "extra-ocaml-path";
    packages = ocamlPackageDerivations ++ allRuntimePackages;
  };
  ocamlinit = ''
    #use "${scope.ocamlfind}/lib/ocaml/${scope.ocaml.version}/site-lib/topfind";;
    Topfind.log:=ignore;;
  '';
  wrappedKernel = scope.jupyter.overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [pkgs.makeWrapper];
    postInstall = ''
      for i in $out/bin/*; do
        filename=$(basename $i)
        # (1) Load the environment from our runtime dependencies derivation.
        #     Sourcing the stdenv is required to actually export all the variables.
        # (2) The kernel expects to run in the environment provided by opam, which
        #     usually has all the transitive dependencies (including stublibs)
        #     installed in the same switch, with the corresponding variables pointed to it.
        #     This is not the case with the nix store, so we have to point it to
        #     the corresponding store paths manually.
        wrapProgram $out/bin/$filename \
          --run 'source ${runtimeEnv.inputDerivation}; source $stdenv/setup' \
          --suffix CAML_LD_LIBRARY_PATH : "$CAML_LD_LIBRARY_PATH"
      done
    '';
  });
in {
  inherit name displayName;
  language = "ocaml";
  argv = [
    "${wrappedKernel}/bin/ocaml-jupyter-kernel"
    "-init"
    (pkgs.writeText "ocamlinit" ocamlinit)
    "--merlin"
    "${scope.merlin}/bin/ocamlmerlin"
    "--verbosity"
    "app"
    "--connection-file"
    "{connection_file}"
  ];
  codemirrorMode = "ocaml";
  logo64 = ./logo64.png;
}
