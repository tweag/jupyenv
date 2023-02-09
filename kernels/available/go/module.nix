{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "go";
  kernelOptions = {
    config,
    name,
    ...
  }: let
    requiredRuntimePackages = [config.nixpkgs.go];
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./../../../modules/kernel.nix args;
  in {
    options =
      {}
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          gophernotes = kernelModule.kernelArgs.pkgs.gophernotes;
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
