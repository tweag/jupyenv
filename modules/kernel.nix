{
  name,
  kernelName,
  self,
  system,
  lib,
  config,
  requiredRuntimePackages ? [],
}: let
  inherit (lib) types;
in {
  options = {
    enable = lib.mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = ''
        Enable ${kernelName} kernel.
      '';
    };

    name = lib.mkOption {
      type = types.str;
      default = "${kernelName}-${name}";
      example = "${kernelName}-example";
      description = ''
        Name of the ${kernelName} kernel.
      '';
    };

    displayName = lib.mkOption {
      type = types.str;
      default = "${config.name} kernel";
      example = "${kernelName} example kernel";
      description = ''
        Display name of the ${kernelName} kernel.
      '';
    };

    requiredRuntimePackages = lib.mkOption {
      type = types.listOf types.package;
      default = requiredRuntimePackages;
      example = lib.literalExpression "[pkgs.example]";
      description = ''
        A list of required runtime packages for this ${kernelName} kernel.
      '';
    };

    runtimePackages = lib.mkOption {
      type = types.listOf types.package;
      default = [];
      description = ''
        A list of user desired runtime packages for this ${kernelName} kernel.
      '';
    };

    nixpkgs = import ./types/nixpkgs.nix {
      inherit lib self system kernelName;
      overlays = import ./types/overlays.nix {inherit lib self config kernelName;};
    };

    kernelArgs = lib.mkOption {
      type = types.lazyAttrsOf types.raw;
      readOnly = true;
      internal = true;
    };

    extraKernelSpc = lib.mkOption {
      default = {
        metadata = {
          debugger = true;
        };
      };
      type = types.attrs;
      description = ''
        Extra kernel spec attributes.
      '';
    };

    build = lib.mkOption {
      type = types.package;
      internal = true;
    };
  };

  kernelArgs = {
    inherit self system;
    inherit
      (config)
      name
      displayName
      requiredRuntimePackages
      runtimePackages
      extraKernelSpc
      ;
    pkgs = config.nixpkgs;
  };
}
