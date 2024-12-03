{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "sage";
  kernelOptions = {
    config,
    name,
    ...
  }: let
    overlay = final: prev: rec {
      sage = prev.sage.override {
        requireSageTests = false;
      };
    };
    pkgs = import self.inputs.nixpkgs {
      inherit system;
      overlays = [overlay];
    };
    requiredRuntimePackages = with pkgs; [
      sage
      python3
      gnused
    ];
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./../../kernel.nix args;
    kernelFunc = {
      self,
      system,
      # custom arguments
      pkgs ? pkgs,
      name ? "sage",
      displayName ? "Sage",
      requiredRuntimePackages ? requiredRuntimePackages,
      runtimePackages ? [],
    }: let
      allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

      env = pkgs.sage;
      wrappedEnv =
        pkgs.runCommand "wrapper-${env.name}"
        {nativeBuildInputs = [pkgs.makeWrapper];}
        ''
          mkdir -p $out/bin
          for i in ${env}/bin/*; do
            filename=$(basename $i)
            ln -s ${env}/bin/$filename $out/bin/$filename
            wrapProgram $out/bin/$filename \
              --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
          done
        '';
    in {
      inherit name displayName;
      language = "python";
      argv = [
        "${wrappedEnv}/bin/sage"
        "--python"
        "-m"
        "sage.repl.ipython_kernel"
        "-f"
        "{connection_file}"
      ];
      codemirrorMode = "python";
      logo64 = ./logo64.png;
      logo32 = ./logo32.png;
    };
  in {
    options =
      {
      }
      // kernelModule.options;
    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        kernelModule.kernelArgs
        // {
          inherit (config);
          pkgs = import config.nixpkgs.path {
            inherit system;
            overlays = [
              overlay
            ];
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
