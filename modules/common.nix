kernelName: {
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
    args = {inherit self system lib config name kernelName;};
    kernelModule = import ./kernel.nix args;
    poetryModule = import ./poetry.nix args;
  in {
    options =
      {}
      // kernelModule.options
      // poetryModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {}
        // kernelModule.kernelArgs
        // poetryModule.kernelArgs;
    };
  };
in {
  options.kernel.${kernelName} = lib.mkOption {
    type = types.attrsOf (types.submodule kernelOptions);
    default = {};
    example = ''
      {
        kernel.${kernelName}."example".enable = true;
      }
    '';
    description = lib.mdDoc ''
      A ${kernelName} kernel for IPython.
    '';
  };
}
