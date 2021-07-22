{ mkDerivation, base, stdenv, lib }:
mkDerivation {
  pname = "my-haskell-package";
  version = "0.1.0.0";
  src = ./.;
  libraryHaskellDepends = [ base ];
  license = lib.licenses.bsd3;
}
