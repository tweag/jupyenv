let
  defaultOverlays = [
    (import ./haskell-overlay.nix)
    (import ./python-overlay.nix)
  ];
in

{ config ? {}, overlays ? defaultOverlays }:

import ./nixpkgs.nix { inherit config overlays; }
