{ callPackage }:

{
  haskell_data = callPackage ./haskell.nix {name="data"; packages=(pkgs: with pkgs; [pkgs.hvega pkgs.PyF pkgs.formatting pkgs.string-qq]);};
  haskell = callPackage ./haskell.nix {};
  python = callPackage ./python.nix {};
}
