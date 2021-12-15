final: prev:
let
  lock = builtins.fromJSON (builtins.readFile ./../flake.lock);
  system = builtins.currentSystem;

  compat = (import (
    let
        lockedCompat = lock.nodes.flake-compat.locked;
      in fetchTarball {
        url = "https://github.com/${lockedCompat.owner}/${lockedCompat.repo}/archive/${lockedCompat.rev}.tar.gz";
        sha256 = lockedCompat.narHash;
      }) {
      src = ./..;
    });

  overrides = compat.result.overlays.haskell;
in
{
  haskellPackages = prev.haskellPackages.override (old: {
    overrides =
      prev.lib.composeExtensions
        (old.overrides or (_: _: {}))
        overrides;
  });
}
