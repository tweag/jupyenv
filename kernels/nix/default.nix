{
  self,
  pkgs,
  nix ? pkgs.nixVersions.stable,
  # https://github.com/nix-community/poetry2nix#mkPoetryPackages
  projectDir ? self + "/kernels/nix",
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

  nix-bin =
    pkgs.runCommand "wrapper-${env.name}"
    {nativeBuildInputs = [pkgs.makeWrapper];}
    ''
      mkdir -p $out/bin
      for i in ${env}/bin/*; do
        filename=$(basename $i)
        ln -s ${env}/bin/$filename $out/bin/$filename
        wrapProgram $out/bin/$filename \
          --set PATH ${nix}/bin
      done
    '';
in
  {
    name ? "nix",
    displayName ? "Nix", # TODO: add Nix version
    language ? "Nix",
    argv ? [
      "${nix-bin}/bin/python"
      "-m"
      "nix-kernel"
      "-f"
      "{connection_file}"
    ],
    codemirror_mode ? "",
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
