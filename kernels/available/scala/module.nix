{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "scala";
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
        scala = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.scala;
          description = lib.mdDoc ''
            Scala package to use with almond.
          '';
        };

        coursier = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.coursier;
          description = lib.mdDoc ''
            Coursier package to use with almond.
          '';
        };

        jdk = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.jdk;
          description = lib.mdDoc ''
            JDK package to use with almond.
          '';
        };

        jre = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.jre;
          description = lib.mdDoc ''
            JRE package to use with almond.
          '';
        };
      }
      // kernelModule.options;
    config = lib.mkIf config.enable {
      kernelArgs =
        {
          inherit (config) scala coursier jdk jre;
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
