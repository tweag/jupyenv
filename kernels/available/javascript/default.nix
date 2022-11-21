{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "javascript",
  displayName ? "Javascript",
  ijavascript ? pkgs.nodePackages.ijavascript,
}: let
  inherit (pkgs) lib stdenv writeScriptBin;
  inherit (lib) makeBinPath;

  # testbook adds a --Kernel argument breaking the javascript kernel
  # https://github.com/nteract/testbook/blob/f6692b41e761addd65497df229b1e75532bdc9c6/testbook/client.py#L29-L30
  ijavascriptSh = writeScriptBin "ijavascript" ''
    #! ${stdenv.shell}
    export PATH="${makeBinPath [ijavascript]}:$PATH"
    if [[ ''${@: -1} == --Kernel* ]] ; then
      ${ijavascript}/bin/ijskernel "''${@:1:$#-1}"
    else
      ${ijavascript}/bin/ijskernel "$@"
    fi
  '';
in {
  inherit name displayName;
  language = "javascript";
  argv = [
    "${ijavascriptSh}/bin/ijavascript"
    "{connection_file}"
  ];
  codemirrorMode = "javascript";
  logo64 = ./logo64.png;
}
