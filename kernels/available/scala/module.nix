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
          example = lib.literalExpression "pkgs.scala";
          description = lib.mdDoc ''
            Scala package to use with almond.
          '';
        };

        coursier = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.coursier;
          example = lib.literalExpression "pkgs.coursier";
          description = lib.mdDoc ''
            Coursier package to use with almond.
          '';
        };

        jdk = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.jdk;
          example = lib.literalExpression "pkgs.jdk";
          description = lib.mdDoc ''
            JDK package to use with almond.
          '';
        };

        jre = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.legacyPackages.${system}.jre;
          example = lib.literalExpression "pkgs.jre";
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
