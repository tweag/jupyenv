{
  kernelName,
  requiredRuntimePackages ? [],
  mkKernel,
}: {
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelOptions = {
    config,
    name,
    ...
  }: let
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./kernel.nix args;
    kernelFunc = {
      self,
      system,
      # custom arguments
      pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
      name ? "bash",
      displayName ? "Bash",
      requiredRuntimePackages ? with pkgs; [bashInteractive coreutils],
      runtimePackages ? [],
      # https://github.com/nix-community/poetry2nix
      poetry2nix ? import "${self.inputs.poetry2nix}/default.nix" {inherit pkgs poetry;},
      poetry ? pkgs.callPackage "${self.inputs.poetry2nix}/pkgs/poetry" {inherit python;},
      # https://github.com/nix-community/poetry2nix#mkPoetryPackages
      projectDir ? self + "/modules/kernels/bash",
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
              --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
          done
        '';
    in {
      inherit name displayName;
      language = "bash";
      argv = [
        "${wrappedEnv}/bin/python"
        "-m"
        "bash_kernel"
        "-f"
        "{connection_file}"
      ];
      codemirrorMode = "shell";
      logo64 = ./kernels/bash/logo64.png;
    };
  in {
    options =
      import ./types/poetry.nix {inherit lib self config kernelName;}
      // kernelModule.options
      // {
        build = lib.mkOption {
          type = types.package;
          internal = true;
        };
      };

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        rec {
          inherit
            (config)
            projectDir
            pyproject
            poetrylock
            editablePackageSources
            extraPackages
            preferWheels
            groups
            ignoreCollisions
            ;
          pkgs = config.nixpkgs;
          python = pkgs.${config.python};
          poetry = pkgs.callPackage "${config.poetry2nix}/pkgs/poetry" {inherit python;};
          poetry2nix = import "${config.poetry2nix}/default.nix" {inherit pkgs poetry;};
          overrides =
            if config.withDefaultOverrides == true
            then poetry2nix.overrides.withDefaults (import config.overrides)
            else import config.overrides;
        }
        // kernelModule.kernelArgs;
    };
  };
in {
  options.kernel.${kernelName} = lib.mkOption {
    type = types.attrsOf (types.submodule kernelOptions);
    default = {};
    example = lib.literalExpression ''
      {
        kernel.${kernelName}."example".enable = true;
      }
    '';
    description = lib.mdDoc ''
      A ${kernelName} kernel for IPython.
    '';
  };
}
