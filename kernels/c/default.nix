{
  self,
  pkgs,
  # https://github.com/nix-community/poetry2nix#mkPoetryEnv
  projectDir ? self + "/kernels/c",
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
    name ? "c",
    displayName ? "C", # TODO: add C version
    language ? "c",
    argv ? [
      "${env}/bin/python"
      "-m"
      "jupyter_c_kernel"
      "-f"
      "{connection_file}"
    ],
    codemirror_mode ? "clike",
    logo64 ? ./logo64.png,
  }: {
    inherit
      name
      displayName
      language
      argv
      codemirror_mode
      logo64
      ;
  }
