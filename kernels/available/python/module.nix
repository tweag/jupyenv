{
  config,
  lib,
  ...
}: let
  types = lib.types;
  parentConfig = config;

  pythonKernelOptions = {
    config,
    name,
    ...
  }: {
    options = {
      name = lib.mkOption {
        type = types.str;
        default = name;
        example = "name";
        description = lib.mdDoc "Name of the python kernel.";
      };
    };
  };
in {
  options.kernel.python = lib.mkOption {
    default = {};
    type = types.attrsOf (types.submodule pythonKernelOptions);
    description = lib.mdDoc ''
      WORKS
    '';
  };
}
