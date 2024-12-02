{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "nix";
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
      name ? "nix",
      displayName ? "Nix",
      requiredRuntimePackages ? [],
      runtimePackages ? [],
      extraKernelSpc,
      nix ? pkgs.nix,
    }: let
      allRuntimePackages =
        requiredRuntimePackages
        ++ runtimePackages
        ++ [
          nix
        ];

      env = pkgs.python3.withPackages (ps: with ps; [nix-kernel]);

      wrappedEnv =
        pkgs.runCommand "wrapper-${env.name}"
        {nativeBuildInputs = [pkgs.makeWrapper];}
        ''
          mkdir -p $out/bin
          for i in ${env}/bin/*; do
            filename=$(basename $i)
            ln -s ${env}/bin/$filename $out/bin/$filename
            wrapProgram $out/bin/$filename \
              --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"\
              --set NIX_PATH "nixpkgs=${pkgs.path}"
          done
        '';
    in
      {
        inherit name displayName;
        language = "nix";
        argv = [
          "${wrappedEnv}/bin/python"
          "-m"
          "nix-kernel"
          "-f"
          "{connection_file}"
        ];
        codemirrorMode = "nix";
        logo64 = ./logo-64x64.png;
      }
      // extraKernelSpc;
  in {
    options =
      {
        nix = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.nix;
          description = ''
            Nix Version
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        {
          inherit (config) nix;
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
