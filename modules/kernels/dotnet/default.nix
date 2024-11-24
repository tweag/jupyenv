{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "dotnet";
  kernelOptions = {
    config,
    name,
    ...
  }: let
    dotnet-interactive =
      config.nixpkgs.callPackage ./package.nix {
      };

    requiredRuntimePackages = [
      dotnet-interactive
    ];
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./../../kernel.nix args;
    kernelFunc = {
      self,
      system,
      # custom arguments
      pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
      name ? "dotnet",
      displayName ? "dotnet",
      requiredRuntimePackages ? with pkgs; [dotnet-interactive],
      runtimePackages ? [],
      extraKernelSpc,
      language ? "csharp",
    }:
      {
        inherit name displayName;
        language = "dotnet";
        argv = [
          "${dotnet-interactive}/bin/dotnet-interactive"
          "jupyter"
          "{connection_file}"
          "--default-kernel"
          "${language}"
        ];
        codemirrorMode = "dotnet";
        logo64 = ./logo-64x64.png;
      }
      // extraKernelSpc;
  in {
    options =
      {
        language = lib.mkOption {
          type = lib.types.enum ["csharp" "fsharp"];
          default = "csharp";
          description = lib.mdDoc ''
            Language flavour of dotnet-interactive kernel
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        {
          inherit (config) language;
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
