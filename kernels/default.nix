{ callPackage }:

{
  iHaskellWith = callPackage ./ihaskell;
  juniperWith = callPackage ./juniper;
  iRWith = callPackage ./irkernel;
  iPythonWith = callPackage ./ipython;
  iRubyWith = callPackage ./iruby;
  iJuliaWith = callPackage ./julia;
  cKernelWith = callPackage ./ckernel;
  ansibleKernel = callPackage ./ansible-kernel;
  xeusCling = callPackage ./xeus-cling;
  iJavascript = callPackage ./ijavascript;
  gophernotes = callPackage ./gophernotes;
}
