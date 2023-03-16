{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "julia";
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
      name ? "julia",
      displayName ? "Julia",
      requiredRuntimePackages ? [],
      runtimePackages ? [],
      julia ? pkgs.julia,
      julia_depot_path ? "~/.julia",
      activateDir ? "",
      ijuliaRev ? "6TIq1",
    }: let
      inherit (pkgs) writeText;
      inherit (pkgs.lib) optionalString;

      startupFile = writeText "startup.jl" ''
        import Pkg
        Pkg.activate("${activateDir}")
        Pkg.instantiate()
      '';

      allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

      env = julia;

      wrappedEnv =
        pkgs.runCommand "wrapper-${env.name}"
        {nativeBuildInputs = [pkgs.makeWrapper];}
        ''
          mkdir -p $out/bin
          for i in ${env}/bin/*; do
            filename=$(basename $i)
            ln -s ${env}/bin/$filename $out/bin/$filename
            wrapProgram $out/bin/$filename \
              --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}" ${optionalString (activateDir != "") ''--add-flags "-L ${startupFile}"''}
          done
        '';
    in {
      inherit name displayName;
      language = "julia";
      argv = [
        "${wrappedEnv}/bin/julia"
        "-i"
        "--startup-file=yes"
        "--color=yes"
        "${julia_depot_path}/packages/IJulia/${ijuliaRev}/src/kernel.jl"
        "{connection_file}"
      ];
      codemirrorMode = "julia";
      logo64 = ./logo64.png;
    };
  in {
    options =
      {
        julia_depot_path = lib.mkOption {
          type = types.str;
          default = "~/.julia";
          example = "~/.julia";
          description = lib.mdDoc ''
            Julia path
          '';
        };

        activateDir = lib.mkOption {
          type = types.str;
          default = "";
          example = "";
          description = lib.mdDoc ''
            Julia activate directory
          '';
        };

        ijuliaRev = lib.mkOption {
          type = types.str;
          default = "6TIq1";
          example = "6TIq1";
          description = lib.mdDoc ''
            iJulia revision
          '';
        };
        julia = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.julia;
          description = lib.mdDoc ''
            Julia Version
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        {
          inherit (config) julia_depot_path activateDir ijuliaRev julia;
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
