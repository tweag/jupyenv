{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.ocaml {
  inherit name;
  inherit (extraArgs) pkgs;
  displayName = "Example OCaml Kernel";
}
