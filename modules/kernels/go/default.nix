{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "go";
  kernelOptions = {
    config,
    name,
    ...
  }: let
    requiredRuntimePackages = [config.nixpkgs.go];
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./../../kernel.nix args;
    kernelFunc = {
      self,
      system,
      # custom arguments
      pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
      name ? "go",
      displayName ? "Go",
      requiredRuntimePackages ? with pkgs; [go],
      runtimePackages ? [],
      gophernotes ? pkgs.gophernotes,
    }: let
      inherit (pkgs) lib stdenv writeScriptBin;

      gophernotesSh = writeScriptBin "gophernotes" ''
        #! ${stdenv.shell}
        export PATH="${lib.makeBinPath [gophernotes]}:$PATH"
        ${gophernotes}/bin/gophernotes "$@"'';

      allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

      env = gophernotesSh;
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
      language = "go";
      argv = [
        "${wrappedEnv}/bin/gophernotes"
        "{connection_file}"
      ];
      codemirrorMode = "go";
      logo64 = ./logo64.png;
    };
  in {
    options =
      {}
      // kernelModule.options;

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        {
          gophernotes = kernelModule.kernelArgs.pkgs.gophernotes;
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
