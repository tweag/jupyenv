final: prev: rec {
  jupyterWith = prev.callPackage ./default.nix {pkgs = final;};
}
