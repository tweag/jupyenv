{ callPackage }:

{
  haskellWith = callPackage ./haskell.nix;
  pythonWith = callPackage ./python.nix;
}
