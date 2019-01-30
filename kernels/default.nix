{ callPackage }:

{
  iHaskellWith = callPackage ./ihaskell.nix;
  juniperWith = callPackage ./juniper.nix;
  iPythonWith = callPackage ./ipython.nix;
  iRubyWith = callPackage ./iruby.nix;
  cKernel = callPackage ./ckernel.nix;
  ansibleKernel = callPackage ./ansible-kernel.nix;
}
