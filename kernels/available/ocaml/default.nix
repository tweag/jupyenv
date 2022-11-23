{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "ocaml",
  displayName ? "OCaml",
  runtimePackages ? [],
  extraRuntimePackages ? [],
  # https://github.com/tweag/opam-nix
  opam-nix ? self.inputs.opam-nix.lib.${system},
}: let
  allRuntimePackages = runtimePackages ++ extraRuntimePackages;

  OcamlKernel = let
    name = "jupyter";
    version = "2.8.0";
    src = pkgs.fetchFromGitHub {
      owner = "akabe";
      repo = "ocaml-jupyter";
      rev = "v${version}";
      sha256 = "sha256-IWbM6rOjcE1QHO+GVl8ZwiZQpNmdBbTdfMZe69D5lIU=";
    };
  in
    opam-nix.buildDuneProject
    {
      pkgs = pkgs.extend (final: _: {zeromq3 = final.zeromq4;});
    }
    name
    src
    {
      # Merlin was specified in the kernel depopts but not pulled in automatically.
      merlin = "*";
    };

  env = OcamlKernel.jupyter;
  wrappedEnv = env.overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [pkgs.makeWrapper];
    postInstall = ''
      for i in $out/bin/*; do
        filename=$(basename $i)
        # The kernel expects to run in the environment provided by opam, which
        # usually has all the transitive dependencies (including stublibs)
        # installed in the same switch, with the corresponding variables pointed to it.
        # This is not the case with the nix store, so we have to point it to
        # the corresponding store paths manually.
        wrapProgram $out/bin/$filename \
          --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}" \
          --set CAML_LD_LIBRARY_PATH "$CAML_LD_LIBRARY_PATH"
      done
    '';
  });
in {
  inherit name displayName;
  language = "ocaml";
  argv = [
    "${wrappedEnv}/bin/ocaml-jupyter-kernel"
    "-init"
    "/home/$USER/.ocamlinit"
    "--merlin"
    "${OcamlKernel.merlin}/bin/ocamlmerlin"
    "--verbosity"
    "app"
    "--connection-file"
    "{connection_file}"
  ];
  codemirrorMode = "ocaml";
  logo64 = ./logo64.png;
}
