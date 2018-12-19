{ nixpkgsPath ? import ./nixpkgs-src.nix }:
let
  fixes = self: pkgs: {
      jupyter = pkgs.jupyter.override { extensions=[]; };
    };
  pkgs = import nixpkgsPath {overlays=[fixes];};
  jupyter = pkgs.jupyter;
  jupyterlab = pkgs.python36Packages.jupyterlab;
  extension = pkgs.nodePackages."@jupyterlab/toc";
in
pkgs.stdenv.mkDerivation {
  name="jlab";
  buildInputs=[ jupyter jupyterlab ] ++ [ extension ];
  shellHook = ''
    export JUPYTER=${jupyter}
    export JUPYTERLAB=${jupyterlab}
    mkdir -p ./out
    cp -r ${jupyterlab}/share/jupyter/lab/* ./out
    chmod -R 755 ./out
    ls ${extension}/lib/node_modules/@jupyterlab/toc
    jupyter labextension install --no-build --app-dir=./out --debug @jupyterlab/toc
    jupyter lab build --app-dir=./out
    '';
}
