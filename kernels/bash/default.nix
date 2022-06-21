{
  self,
  pkgs,
  # https://github.com/nix-community/poetry2nix#mkPoetryPackages
  projectDir ? self + "/kernels/bash",
  pyproject ? projectDir + "/pyproject.toml",
  poetrylock ? projectDir + "/poetry.lock",
  overrides ? pkgs.poetry2nix.overrides.withDefaults (import ./overrides.nix),
  python ? pkgs.python3,
  editablePackageSources ? {},
  extraPackages ? ps: [],
  preferWheels ? false,
}: let
  env = pkgs.poetry2nix.mkPoetryEnv {
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
in
  {
    name ? "bash",
    displayName ? "Bash", # TODO: add Bash version
    language ? "bash",
    argv ? [
      "${env}/bin/python"
      "-m"
      "bash_kernel"
      "-f"
      "{connection_file}"
    ],
    codemirrorMode ? "shell",
    logo64 ? ./logo64.png,
  }: {
    inherit
      name
      displayName
      language
      argv
      codemirrorMode
      logo64
      ;
  }
