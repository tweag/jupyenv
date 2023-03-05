{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "rust";
  kernelOptions = {
    config,
    name,
    ...
  }: let
    requiredRuntimePackages = [
      config.nixpkgs.cargo
      config.nixpkgs.gcc
      config.nixpkgs.binutils-unwrapped
    ];
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./../../../modules/kernel.nix args;
  in {
    options =
      {
        evcxr = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.evcxr;
          example = lib.literalExpression "pkgs.evcxr";
          description = lib.mdDoc ''
            An evaluation context for Rust.
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        kernelModule.kernelArgs
        // {
          inherit (config) evcxr;
        };
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
