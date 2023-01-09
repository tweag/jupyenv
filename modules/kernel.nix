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

    nixpkgs = lib.mkOption {
      type = types.path;
      default = self.inputs.nixpkgs;
      defaultText = lib.literalExpression "self.inputs.nixpkgs";
      example = lib.literalExpression "self.inputs.nixpkgs";
      description = lib.mdDoc ''
        nixpkgs flake input to be used for this ${kernelName} kernel.
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
    pkgs = config.nixpkgs.legacyPackages.${system};
  };
}
