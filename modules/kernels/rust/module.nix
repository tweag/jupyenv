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
    kernelModule = import ./../../kernel.nix args;
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

        rust-overlay = lib.mkOption {
          type = types.path;
          default = self.inputs.rust-overlay;
          defaultText = lib.literalExpression "self.inputs.rust-overlay";
          example = lib.literalExpression "self.inputs.rust-overlay";
          description = lib.mdDoc ''
            An overlay for binary distributed rust toolchains. Adds `rust-bin` to nixpkgs which is needed for the Rust kernel.
          '';
        };
      }
      // kernelModule.options;
    config = lib.mkIf config.enable {
      kernelArgs =
        kernelModule.kernelArgs
        // {
          inherit (config) evcxr rust-overlay;
          pkgs = import config.nixpkgs.path {
            inherit system;
            overlays = [config.rust-overlay.overlays.default];
          };
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
