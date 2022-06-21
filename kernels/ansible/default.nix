{
  self,
  pkgs,
  # https://github.com/nix-community/poetry2nix#mkPoetryEnv
  projectDir ? self + "/kernels/ansible",
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
    name ? "ansible",
    displayName ? "Ansible", # TODO: add Ansible version
    language ? "ansible",
    argv ? [
      "${env}/bin/python"
      "-m"
      "ansible_kernel"
      "-f"
      "{connection_file}"
    ],
    codemirrorMode ? "yaml",
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
