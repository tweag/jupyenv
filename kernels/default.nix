{ callPackage }:

{
  iHaskellWith = callPackage ./ihaskell.nix;
  iPythonWith = callPackage ./ipython.nix;
}
