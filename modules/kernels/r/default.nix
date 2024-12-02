{
  self,
  system,
  config,
  lib,
  mkKernel,
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
    kernelModule = import ./../../kernel.nix args;
    kernelFunc = {
      self,
      system,
      # custom arguments
      pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
      name ? "r",
      displayName ? "R",
      requiredRuntimePackages ? [],
      runtimePackages ? [],
      extraKernelSpc,
      rWrapper ? pkgs.rWrapper,
      rPackages ? pkgs.rPackages,
      extraRPackages ? (_: []),
    }: let
      env = rWrapper.override {
        packages = (extraRPackages rPackages) ++ [rPackages.IRkernel];
      };

      allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

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
    in
      {
        inherit name displayName;
        language = "r";
        argv = [
          "${wrappedEnv}/bin/R"
          "--slave"
          "-e"
          "IRkernel::main()"
          "--args"
          "{connection_file}"
        ];
        codemirrorMode = "R";
        logo64 = ./logo-64x64.png;
      }
      // extraKernelSpc;
  in {
    options =
      {
        rWrapper = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.rWrapper;
          defaultText = lib.literalExpression "pkgs.rWrapper";
          description = ''
            R version from nixpkgs.
          '';
        };

        rPackages = lib.mkOption {
          type = types.attrs;
          default = config.nixpkgs.rPackages;
          defaultText = lib.literalExpression "pkgs.rPackages";
          description = ''
            A set of R packages.
          '';
        };

        extraRPackages = lib.mkOption {
          type = types.functionTo (types.listOf types.package);
          default = _: [];
          defaultText = lib.literalExpression "_: []";
          example = lib.literalExpression "ps: [ps.foreign ps.ggplot2]";
          description = ''
            Extra R packages.
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
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
    example = lib.literalExpression ''
      {
        kernel.${kernelName}."example".enable = true;
      }
    '';
    description = ''
      A ${kernelName} kernel for IPython.
    '';
  };
}
