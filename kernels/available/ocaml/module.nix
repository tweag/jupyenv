{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "ocaml";
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
        opam-nix = lib.mkOption {
          type = types.path;
          default = self.inputs.opam-nix;
          defaultText = lib.literalExpression "self.inputs.opam-nix";
          example = lib.literalExpression "self.inputs.opam-nix";
          description = lib.mdDoc ''
            opam-nix flake input to be used for this ${kernelName} kernel.
          '';
        };

        requiredOcamlPackages = lib.mkOption {
          type = types.attrs;
          default = {merlin = "*";};
          defaultText = lib.literalExpression ''
            { merlin = "*"; }
          '';
          example = lib.literalExpression ''
            { merlin = "4.7.1-500"; }
          '';
          description = lib.mdDoc ''
            Attribute set of required OCaml packages.
          '';
        };

        ocamlPackages = lib.mkOption {
          type = types.attrs;
          default = {};
          example = lib.literalExpression ''
            {
              hex = "*";
              owl = "*";
            }
          '';
          description = lib.mdDoc ''
            Attribute set of user desired OCaml packages.
          '';
        };

        opamProjects = lib.mkOption {
          type = types.listOf types.path;
          default = [];
          example = lib.literalExpression ''
            [
              self.inputs.myOpamProject
            ]
          '';
          description = ''
            List of directories containing `.opam` files.
          '';
        };

        opamNixArgs = lib.mkOption {
          type = types.attrs;
          default = {};
          description = ''
            See the opam-nix [queryToScope](https://github.com/tweag/opam-nix#querytoscope) first argument which is the same as `buildDunePackage`.
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          inherit (config) opam-nix requiredOcamlPackages ocamlPackages opamProjects opamNixArgs;
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
