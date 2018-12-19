{ callPackage }:

{
  haskell = callPackage ./kernels/haskell.nix {};
  python = callPackage ./kernels/python.nix {};
}
