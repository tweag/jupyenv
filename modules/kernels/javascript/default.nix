{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "javascript";
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
      name ? "javascript",
      displayName ? "Javascript",
      requiredRuntimePackages ? [],
      runtimePackages ? [],
      ijavascript ? pkgs.nodePackages.ijavascript,
    }: let
      inherit (pkgs) lib stdenv writeScriptBin;
      inherit (lib) makeBinPath;

      # testbook adds a --Kernel argument breaking the javascript kernel
      # https://github.com/nteract/testbook/blob/f6692b41e761addd65497df229b1e75532bdc9c6/testbook/client.py#L29-L30
      env = writeScriptBin "ijavascript" ''
        #! ${stdenv.shell}
        export PATH="${makeBinPath [ijavascript]}:$PATH"
        if [[ ''${@: -1} == --Kernel* ]] ; then
          ${ijavascript}/bin/ijskernel "''${@:1:$#-1}"
        else
          ${ijavascript}/bin/ijskernel "$@"
        fi
      '';

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
      inherit name displayName;
      language = "javascript";
      argv = [
        "${wrappedEnv}/bin/ijavascript"
        "{connection_file}"
      ];
      codemirrorMode = "javascript";
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
          ijavascript = config.nixpkgs.nodePackages.ijavascript;
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
