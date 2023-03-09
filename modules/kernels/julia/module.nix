{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "julia";
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
        julia_depot_path = lib.mkOption {
          type = types.str;
          default = "~/.julia";
          example = "~/.julia";
          description = lib.mdDoc ''
            Julia path
          '';
        };

        activateDir = lib.mkOption {
          type = types.str;
          default = "";
          example = "";
          description = lib.mdDoc ''
            Julia activate directory
          '';
        };

        ijuliaRev = lib.mkOption {
          type = types.str;
          default = "6TIq1";
          example = "6TIq1";
          description = lib.mdDoc ''
            iJulia revision
          '';
        };
        julia = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.julia;
          description = lib.mdDoc ''
            Julia Version
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          inherit (config) julia_depot_path activateDir ijuliaRev julia;
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
