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
      description = lib.mdDoc ''
        Enable ${kernelName} kernel.
      '';
    };

    name = lib.mkOption {
      type = types.str;
      default = "${kernelName}-${name}";
      example = "${kernelName}-example";
      description = lib.mdDoc ''
        Name of the ${kernelName} kernel.
      '';
    };

    displayName = lib.mkOption {
      type = types.str;
      default = "${config.name} kernel";
      example = "${kernelName} example kernel";
      description = lib.mdDoc ''
        Display name of the ${kernelName} kernel.
      '';
    };

    requiredRuntimePackages = lib.mkOption {
      type = types.listOf types.package;
      default = requiredRuntimePackages;
      example = lib.literalExpression "[pkgs.example]";
      description = lib.mdDoc ''
        A list of required runtime packages for this ${kernelName} kernel.
      '';
    };

    runtimePackages = lib.mkOption {
      type = types.listOf types.package;
      default = [];
      description = lib.mdDoc ''
        A list of user desired runtime packages for this ${kernelName} kernel.
      '';
    };

    nixpkgs = import ./types/nixpkgs.nix {
      inherit lib self system;
      overlays = import ./types/overlays.nix {inherit lib self config kernelName;};
    };

    kernelArgs = lib.mkOption {
      type = types.lazyAttrsOf types.raw;
      readOnly = true;
      internal = true;
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
      ;
    pkgs = config.nixpkgs;
  };
}
