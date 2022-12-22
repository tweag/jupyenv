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
    args = {inherit self system lib config name kernelName;};
    kernelModule = import ./../../../modules/kernel.nix args;
  in {
    options =
      {
        requiredRuntimePackages = lib.mkOption {
          type = types.listOf types.package;
          default = [config.nixpkgs.legacyPackages.${system}.go];
          description = ''
            A list of runtime packages required by ${kernelName} kernel.
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          inherit (config) requiredRuntimePackages;
          gophernotes = kernelModule.kernelArgs.pkgs.gophernotes;
        }
        // kernelModule.kernelArgs;
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
