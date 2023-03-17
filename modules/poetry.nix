{
  kernelName,
  requiredRuntimePackages ? [],
  mkKernel,
  argvKernelName,
  codemirrorMode,
  language,
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
      pkgs,
      name,
      argvKernelName,
      codemirrorMode,
      displayName,
      language,
      requiredRuntimePackages,
      runtimePackages,
      # https://github.com/nix-community/poetry2nix
      poetry2nix,
      poetry,
      # https://github.com/nix-community/poetry2nix#mkPoetryPackages
      projectDir,
      pyproject,
      poetrylock,
      overrides,
      python,
      editablePackageSources,
      extraPackages,
      preferWheels,
      groups,
      ignoreCollisions,
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
      inherit name codemirrorMode displayName language;
      argv = [
        "${wrappedEnv}/bin/python"
        "-m"
        "${argvKernelName}"
        "-f"
        "{connection_file}"
      ];
      logo64 = projectDir + "/logo64.png";
    };
  in {
    options =
      import ./types/poetry.nix {inherit self lib config argvKernelName codemirrorMode kernelName language;}
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
            argvKernelName
            codemirrorMode
            language
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
