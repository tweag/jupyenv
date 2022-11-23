{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "python",
  displayName ? "Python3",
  # https://github.com/nix-community/poetry2nix
  poetry2nix ? import "${self.inputs.poetry2nix}/default.nix" {inherit pkgs poetry;},
  poetry ? pkgs.callPackage "${self.inputs.poetry2nix}/pkgs/poetry" {inherit python;},
  # https://github.com/nix-community/poetry2nix#mkPoetryEnv
  projectDir ? self + "/kernels/available/python",
  pyproject ? projectDir + "/pyproject.toml",
  poetrylock ? projectDir + "/poetry.lock",
  overrides ? import ./overrides.nix,
  python ? pkgs.python3,
  editablePackageSources ? {},
  extraPackages ? ps: [],
  preferWheels ? false,
}: let
  env-overrides = poetry2nix.overrides.withDefaults overrides;

  env = poetry2nix.mkPoetryEnv {
    inherit
      projectDir
      pyproject
      poetrylock
      python
      editablePackageSources
      extraPackages
      preferWheels
      ;
    overrides = env-overrides;
  };
in {
  inherit name displayName;
  language = "python";
  argv = [
    "${env}/bin/python"
    "-m"
    "ipykernel_launcher"
    "-f"
    "{connection_file}"
  ];
  codemirrorMode = "python";
  logo64 = ./logo64.png;
}
