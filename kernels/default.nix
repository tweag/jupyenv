{ callPackage }:

{
  iHaskellWith = callPackage ./ihaskell;
  iRWith = callPackage ./irkernel;
  iPythonWith = callPackage ./ipython;
  iRubyWith = callPackage ./iruby;
  iJuliaWith = callPackage ./ijulia;
  iNixKernel = callPackage ./inix;
  cKernelWith = callPackage ./ckernel;
  ansibleKernel = callPackage ./ansible-kernel;
  bashKernel = callPackage ./bash-kernel;
  xeusCling = callPackage ./xeus-cling;
  iJavascript = callPackage ./ijavascript;
  gophernotes = callPackage ./gophernotes;
  rustWith = callPackage ./rust;
  ocamlWith = callPackage ./ocaml;
}
