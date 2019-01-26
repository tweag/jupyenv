{ pkgs ? import <nixpkgs> {} }:
let 
  iruby = pkgs.bundlerApp {
      pname = "iruby";
      gemdir = ./.;
      exes = [ "iruby" ];
    };

  pythonEnv = pkgs.python3.withPackages (p: with p; [ jupyter ipykernel ] );

in
  pkgs.mkShell {
    name="iruby-env";
    buildInputs=[ iruby pythonEnv ];
  }
