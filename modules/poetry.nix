{
  kernelName,
  requiredRuntimePackages ? [],
  argvKernelName,
  codemirrorMode,
  language,
}: {
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelOptions = {
    config,
    name,
    ...
  }: let
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./kernel.nix args;

    kernelFunc = {
      pkgs,
      name,
      displayName,
      requiredRuntimePackages,
      runtimePackages,
      projectDir,
      env,
      self,
      system,
    }: let
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
    in {
      inherit name codemirrorMode displayName language;
      argv = [
        "${wrappedEnv}/bin/python"
        "-m"
        "${argvKernelName}"
        "-f"
        "{connection_file}"
      ];
      logo64 = projectDir + "/logo64.png";
    };
  in {
    options =
      import ./types/poetry.nix {inherit self lib config argvKernelName codemirrorMode kernelName language;}
      // kernelModule.options
      // {
        build = lib.mkOption {
          type = types.package;
          internal = true;
        };
      };

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        {
          inherit
            (config)
            env
            projectDir
            ;
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
