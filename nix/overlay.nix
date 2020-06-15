_: pkgs:

pkgs // {
  jupyterWith = import ../. { inherit pkgs; };
}
