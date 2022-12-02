{
  availableKernels,
  name,
  extraArgs,
}:
availableKernels.ocaml {
  inherit name;
  inherit (extraArgs) system;
  displayName = "Example OCaml Kernel";
}
