{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "r";
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
        rWrapper = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.rWrapper;
          description = lib.mdDoc ''
            R version from nixpkgs.
          '';
        };

        rPackages = lib.mkOption {
          type = types.attrs;
          default = config.nixpkgs.legacyPackages.${system}.rPackages;
          description = lib.mdDoc ''
            A set of R packages.
          '';
        };

        extraRPackages = lib.mkOption {
          type = types.functionTo (types.listOf types.package);
          default = _: [];
          example = "(p: [p.foreign p.ggplot2])";
          description = lib.mdDoc ''
            Extra R packages.
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          inherit (config) rWrapper rPackages extraRPackages;
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
