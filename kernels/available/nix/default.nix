{
  self,
  pkgs,
  name ? "nix",
  displayName ? "Nix",
  nix ? pkgs.nixVersions.stable,
  runtimePackages ? [nix],
  extraRuntimePackages ? [],
  nixpkgsPath ? pkgs.path,
  # https://github.com/nix-community/poetry2nix#mkPoetryPackages
  projectDir ? self + "/kernels/available/nix",
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

  allRuntimePackages = runtimePackages ++ extraRuntimePackages;

  wrappedEnv =
    pkgs.runCommand "wrapper-${env.name}"
    {nativeBuildInputs = [pkgs.makeWrapper];}
    ''
      mkdir -p $out/bin
      for i in ${env}/bin/*; do
        filename=$(basename $i)
        ln -s ${env}/bin/$filename $out/bin/$filename
        wrapProgram $out/bin/$filename \
          --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"\
          --set NIX_PATH "nixpkgs=${nixpkgsPath}"
      done
    '';
in {
  inherit name displayName;
  language = "Nix";
  argv = [
    "${wrappedEnv}/bin/python"
    "-m"
    "nix-kernel"
    "-f"
    "{connection_file}"
  ];
  logo64 = ./logo64.png;
}
