{
  name,
  kernelName,
  self,
  system,
  lib,
  config,
}: let
  inherit (lib) types;
in {
  options = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = lib.mdDoc ''
        Enable ${kernelName} kernel.
      '';
    };

    name = lib.mkOption {
      type = types.str;
      default = "${kernelName}-${name}";
      example = "example";
      description = lib.mdDoc ''
        Name of the ${kernelName} kernel.
      '';
    };

    displayName = lib.mkOption {
      type = types.str;
      default = "${kernelName} ${config.name} kernel";
      example = "${kernelName} example kernel";
      description = lib.mdDoc ''
        Display name of the ${kernelName} kernel.
      '';
    };

    runtimePackages = lib.mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        A list of runtime packages available in this ${kernelName} kernel.
      '';
    };

    kernelArgs = lib.mkOption {
      type = types.lazyAttrsOf types.raw;
      readOnly = true;
      internal = true;
    };
  };

  kernelArgs = {
    inherit self system;
    inherit
      (config)
      name
      displayName
      runtimePackages
      ;
  };
}
