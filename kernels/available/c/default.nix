{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "c",
  displayName ? "C",
  # https://github.com/nix-community/poetry2nix
  poetry2nix ? import "${self.inputs.poetry2nix}/default.nix" {inherit pkgs poetry;},
  poetry ? pkgs.callPackage "${self.inputs.poetry2nix}/pkgs/poetry" {inherit python;},
  # https://github.com/nix-community/poetry2nix#mkPoetryEnv
  projectDir ? self + "/kernels/available/c",
  pyproject ? projectDir + "/pyproject.toml",
  poetrylock ? projectDir + "/poetry.lock",
  overrides ? poetry2nix.overrides.withDefaults (import ./overrides.nix),
  python ? pkgs.python3,
  editablePackageSources ? {},
  extraPackages ? ps: [],
  preferWheels ? false,
}: let
  env = poetry2nix.mkPoetryEnv {
    inherit
      projectDir
      pyproject
      poetrylock
      overrides
      python
      editablePackageSources
      extraPackages
      preferWheels
      ;
  };
in {
  inherit name displayName;
  language = "c";
  argv = [
    "${env}/bin/python"
    "-m"
    "jupyter_c_kernel"
    "-f"
    "{connection_file}"
  ];
  codemirrorMode = "clike";
  logo64 = ./logo64.png;
}
