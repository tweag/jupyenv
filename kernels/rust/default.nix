{
  self,
  pkgs,
  evcxr ? pkgs.evcxr,
  # TODO: extra packages
}: {
  name ? "rust",
  displayName ? "Rust", # TODO: add Rust version
  language ? "rust",
  argv ? [
    "${evcxr}/bin/evcxr_jupyter"
    "--control_file"
    "{connection_file}"
  ],
  codemirrorMode ? "rust",
  logo64 ? ./logo64.png,
  logo32 ? ./logo32.png,
}: {
  inherit
    name
    displayName
    language
    argv
    codemirrorMode
    logo64
    ;
}
