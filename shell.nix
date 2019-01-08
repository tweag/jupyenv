{ nixpkgsPath ? ./nix }:
let
  pkgs = import nixpkgsPath {};
  jupyterlab-extended = import ./. {};
in
pkgs.mkShell {
  name="jupyterlab-shell";
  buildInputs=[ jupyterlab-extended ];
  shellHook = ''
    export JUPYTERLAB=${jupyterlab-extended}
    '';
}
