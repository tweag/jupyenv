{
  kernelName,
  requiredRuntimePackages ? [],
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
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        rec {
          inherit
            (config)
            ignoreCollisions
            poetryEnv
            ;
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
