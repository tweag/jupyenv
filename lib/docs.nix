{
  self,
  system,
  pkgs,
  lib,
  python,
  nix-dart,
  jupyterLib,
}: rec {
  mkdocs = python.withPackages (p: [
    p.mkdocs
    p.mkdocs-material
    p.mkdocs-material-extensions
    p.markdown-it-py
    p.beautifulsoup4
    p.docopt
  ]);

  docs = pkgs.stdenv.mkDerivation {
    name = "jupyenv-docs";
    src = self;
    nativeBuildInputs = [mkdocs pkgs.dart-sass];
    buildPhase = ''
      sass docs/sass/home/style.scss docs/stylesheets/home.css
      cp ${jupyterLib.options.optionsJSON}/share/doc/nixos/options.json ./options.json
      python docs/python-scripts/options.py html ./options.json docs/overrides/optionsContent.html
      mkdocs build --site-dir dist
    '';
    installPhase = ''
      mkdir $out
      cp -R dist/* $out/
      cp ${jupyterLib.options.optionsJSON}/share/doc/nixos/options.json $out/options.json
    '';
  };
}
