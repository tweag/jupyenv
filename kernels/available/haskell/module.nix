{
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelName = "haskell";
  kernelOptions = {
    config,
    name,
    ...
  }: let
    requiredRuntimePackages = [
      config.nixpkgs.legacyPackages.${system}.haskell.compiler.${config.haskellCompiler}
    ];
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./../../../modules/kernel.nix args;
  in {
    options =
      {
        ihaskell = lib.mkOption {
          type = types.path;
          default = self.inputs.ihaskell;
          example = ''
            self.inputs.ihaskell
          '';
          description = lib.mdDoc ''
            ihaskell flake input to be used for this ${kernelName} kernel.
          '';
        };

        haskellCompiler = lib.mkOption {
          type = types.str;
          default = "ghc902";
          example = "ghc902";
          description = lib.mdDoc ''
            haskell compiler
          '';
        };

        extraHaskellFlags = lib.mkOption {
          type = types.str;
          default = "-M3g -N2";
          example = "-M3g -N2";
          description = lib.mdDoc ''
            haskell compiler flags
          '';
        };

        extraHaskellPackages = lib.mkOption {
          type = types.functionTo (types.listOf types.package);
          default = _: [];
          example = "(_: [])";
          description = lib.mdDoc ''
            extra haskell packages
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        {
          inherit (config) requiredRuntimePackages extraHaskellFlags extraHaskellPackages;
          haskellKernelPkg = import "${config.ihaskell}/release.nix";
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
