{ config ? {}
, overlays ? []}:
let
  nixpkgsPath = import ./nixpkgs-src.nix;
in 
import nixpkgsPath {
  config = config;
  overlays = [ 
               (import ./haskell-overlay.nix)
               (import ./python-overlay.nix)
             ] ++ overlays;
}
