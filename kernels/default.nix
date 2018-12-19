{ callPackage }:

{
  haskell = callPackage ./haskell.nix {};
  python = callPackage ./python.nix {};
}
