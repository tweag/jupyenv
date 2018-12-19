let
  config = {
    packageOverrides = pkgs: {
      haskellPackages = pkgs.haskellPackages.override {
        overrides = self: super: {
          zeromq4-haskell = pkgs.haskell.lib.dontCheck super.zeromq4-haskell;
        };
      };
    };
  };
in
with (import (import ./nixpkgs-src.nix) { inherit config; });
callPackage ./kernels.nix {}
