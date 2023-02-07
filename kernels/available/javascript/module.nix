{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "javascript";
  kernelOptions = {
    config,
    name,
    ...
  }: let
    args = {inherit self system lib config name kernelName;};
    kernelModule = import ./../../../modules/kernel.nix args;
  in {
    options =
      {}
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          ijavascript = config.nixpkgs.nodePackages.ijavascript;
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
