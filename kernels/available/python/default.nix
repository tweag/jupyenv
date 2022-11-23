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
  runtimePackages ?
    with pkgs; [
      bashInteractive
      coreutils
    ],
  extraRuntimePackages ? with pkgs; [sox],
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
          --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
      done
    '';
in {
  inherit name displayName;
  language = "python";
  argv = [
    "${wrappedEnv}/bin/python"
    "-m"
    "ipykernel_launcher"
    "-f"
    "{connection_file}"
  ];
  codemirrorMode = "python";
  logo64 = ./logo64.png;
}
