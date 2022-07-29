{
  self,
  pkgs,
  ijavascript ? pkgs.nodePackages.ijavascript,
}: let
  inherit (pkgs) lib stdenv writeScriptBin;
  inherit (lib) makeBinPath;

  ijavascriptSh = writeScriptBin "ijavascript" ''
    #! ${stdenv.shell}
    export PATH="${makeBinPath [ijavascript]}:$PATH"
    ${ijavascript}/bin/ijskernel "$@"
  '';
in
  {
    name ? "javascript",
    displayName ? "Javascript", # TODO: add version
    language ? "javascript",
    argv ? [
      "${ijavascriptSh}/bin/ijavascript"
      "{connection_file}"
    ],
    codemirrorMode ? "javascript",
    logo64 ? ./logo64.png,
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
