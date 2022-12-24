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
        JULIA_DEPOT_PATH = lib.mkOption {
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
          default = "AQu2H";
          example = "AQu2H";
          description = lib.mdDoc ''
            Julia revision
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          inherit (config) JULIA_DEPOT_PATH activateDir ijuliaRev;
          julia-bin = kernelModule.nixpkgs.legacyPackages.${system}.julia-bin;
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
