{
  self,
  system,
  # custom arguments
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "nix",
  displayName ? "Nix",
  nix ? pkgs.nixVersions.stable,
  requiredRuntimePackages ? [nix],
  runtimePackages ? [],
  nixpkgsPath ? pkgs.path,
  # https://github.com/nix-community/poetry2nix
  poetry2nix ? import "${self.inputs.poetry2nix}/default.nix" {inherit pkgs poetry;},
  poetry ? pkgs.callPackage "${self.inputs.poetry2nix}/pkgs/poetry" {inherit python;},
  # https://github.com/nix-community/poetry2nix#mkPoetryPackages
  projectDir ? self + "/modules/kernels/nix",
  pyproject ? projectDir + "/pyproject.toml",
  poetrylock ? projectDir + "/poetry.lock",
  overrides ? poetry2nix.overrides.withDefaults (import ./overrides.nix),
  python ? pkgs.python3,
  editablePackageSources ? {},
  extraPackages ? ps: [],
  preferWheels ? false,
  groups ? ["dev"],
  ignoreCollisions ? false,
}: let
  env =
    (poetry2nix.mkPoetryEnv {
      inherit
        projectDir
        pyproject
        poetrylock
        overrides
        python
        editablePackageSources
        extraPackages
        preferWheels
        groups
        ;
    })
    .override (args: {inherit ignoreCollisions;});

  allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

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
