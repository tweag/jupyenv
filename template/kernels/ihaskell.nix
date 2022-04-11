{pkgs}:
pkgs.jupyterWith.kernels.iHaskellWith {
  name = "ihaskell-flake";
  packages = p: with p; [vector aeson];
  extraIHaskellFlags = "--codemirror Haskell"; # for jupyterlab syntax highlighting
  haskellPackages = pkgs.haskellPackages;
}
