let
  pkgs = import <nixpkgs> {};
in
  import ./. {
    poetry2nix = pkgs.poetry2nix;
    python = pkgs.python3;
    lib = pkgs.lib;
  }
