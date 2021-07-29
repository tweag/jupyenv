{ callPackage }:

{
  iHaskellWith = callPackage ./ihaskell;
  juniperWith = callPackage ./juniper;
  iRWith = callPackage ./irkernel;
  iPythonWith = callPackage ./ipython;
  iRubyWith = callPackage ./iruby;
  iJuliaWith = callPackage ./ijulia;
  iNixKernel = callPackage ./inix;
  cKernelWith = callPackage ./ckernel;
  ansibleKernel = callPackage ./ansible-kernel;
  xeusCling = callPackage ./xeus-cling;
  iJavascript = callPackage ./ijavascript;
  gophernotes = callPackage ./gophernotes;
  rustWith = callPackage ./rust;
  ocamlWith = callPackage ./ocaml;
}
