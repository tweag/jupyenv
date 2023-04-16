{
  kernelName,
  requiredRuntimePackages ? [],
  mkKernel,
  kernelFunc,
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
            poetryEnv
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
