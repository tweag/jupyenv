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

  nixpkgsLocked = lock.nodes.nixpkgs.locked;

  nixpkgs = fetchTarball "https://api.${nixpkgsLocked.host or "github.com"}/repos/${nixpkgsLocked.owner}/${nixpkgsLocked.repo}/tarball/${nixpkgsLocked.rev}";

in
  import nixpkgs
