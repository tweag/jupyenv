{ pkgs ? import ./nix {}, extensions }:

# Creates a JUPYTERLAB_DIR with the given extensions.
# This operation is impure
pkgs.stdenv.mkDerivation {
  name = "jupyterlab-extended";
  phases = "installPhase";
  buildInputs = with pkgs; [ python36Packages.jupyterlab nodejs ];
  installPhase = ''
    export HOME=$TMP
    jupyter labextension install ${pkgs.lib.concatStringsSep " " extensions} --app-dir=$out
    rm -rf $out/staging/node_modules
  '';
}
