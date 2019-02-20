{ callPackage }:

{
  iHaskellWith = callPackage ./ihaskell;
  juniperWith = callPackage ./juniper;
  iPythonWith = callPackage ./ipython;
  iRubyWith = callPackage ./iruby;
  cKernel = callPackage ./ckernel;
  ansibleKernel = callPackage ./ansible-kernel;
}
