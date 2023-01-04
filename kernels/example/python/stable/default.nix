{
  pkgs,
  pkgs_stable,
  ...
}: {
  kernel.python.example = {
    enable = true;
    nixpkgs = pkgs_stable;
  };
}
