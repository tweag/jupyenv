{
  self,
  system,
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
      # config.nixpkgs.haskell.compiler.${config.haskellCompiler}
    ];
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./../../kernel.nix args;
    kernelFunc = {
      self,
      system,
      pkgs,
      name,
      displayName,
      requiredRuntimePackages,
      runtimePackages ? [],
      haskellKernelPkg,
      haskellCompiler,
      extraHaskellFlags ? "-M3g -N2",
      extraHaskellPackages ? (_: []),
      extraKernelSpc,
    }: let
      allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

      env = haskellKernelPkg {
        packages = extraHaskellPackages;
        rtsopts = extraHaskellFlags;
        extraEnvironmentBinaries = allRuntimePackages;
      };
      # kernelspec = let
      #   wrappedEnv =
      #     pkgs.runCommand "wrapper-${env.name}"
      #     {nativeBuildInputs = [pkgs.makeWrapper];}
      #     ''
      #       mkdir -p $out/bin
      #       for i in ${env}/bin/*; do
      #         filename=$(basename $i)
      #         ln -s ${env}/bin/$filename $out/bin/$filename
      #         wrapProgram $out/bin/$filename \
      #           --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
      #       done
      #     '';
      # in
      #   wrappedEnv;
    in
      {
        inherit name displayName env;
        language = "haskell";
        # See https://github.com/IHaskell/IHaskell/pull/1191
        # argv = kernelspec.argv ++ ["--codemirror" "Haskell"];
        # env = kernelspec;
        codemirrorMode = "Haskell";
        logo64 = ./logo-64x64.png;
      }
      // extraKernelSpc;
  in {
    options =
      {
        ihaskell = lib.mkOption {
          type = types.path;
          default = self.inputs.ihaskell;
          defaultText = lib.literalExpression "self.inputs.ihaskell";
          example = lib.literalExpression "self.inputs.ihaskell";
          description = lib.mdDoc ''
            ihaskell flake input to be used for this ${kernelName} kernel.
          '';
        };

        haskellCompiler = lib.mkOption {
          type = types.str;
          default = "ghc910";
          example = "ghc910";
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
          type = types.functionTo (types.listOf (types.nullOr types.package));
          default = _: [];
          defaultText = lib.literalExpression "ps: []";
          example = lib.literalExpression "ps: [ps.lens ps.vector]";
          description = lib.mdDoc ''
            extra haskell packages
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      build = (kernelFunc config.kernelArgs).env;
      kernelArgs =
        {
          inherit (config) extraHaskellFlags extraHaskellPackages haskellCompiler;
          haskellKernelPkg =
            ((config.nixpkgs).appendOverlays [
              (_: _: {nix-filter = self.inputs.ihaskell.inputs.nix-filter;})
              (import (config.ihaskell + "/nix/overlay-9.8.nix"))
              (import (config.ihaskell + "/nix/overlay-9.6.nix"))
              (import (config.ihaskell + "/nix/overlay-9.10.nix"))
              (sel: sup: {
                haskell =
                  sup.haskell
                  // {
                    packages =
                      sup.haskell.packages
                      // {
                        ghc910 = sup.haskell.packages.ghc910.override {
                          overrides = self: super: {
                            # ghc-syntax-highlighter = self.ghc-syntax-highlighter;
                            # ghc-lib-parser = self.ghc-lib-parser_9_8_3_20241022;
                            # ghc-lib-parser-ex = self.ghc-lib-parser-ex_9_8_0_2;
                            ghc-syntax-highlighter = self.ghc-syntax-highlighter_0_0_12_0;
                            uuid-types = self.uuid-types_1_0_6;
                            uuid = self.uuid_1_3_16;
                            # https://github.com/ndmitchell/hlint/issues/1593
                            hlint =
                              self
                              .hlint_3_8
                              .overrideAttrs (old: {
                                src = sel.fetchFromGitHub {
                                  owner = "ndmitchell";
                                  repo = "hlint";
                                  rev = "7aafde56f6bc526aedb95fb282d8fd2b4ea290cc";
                                  sha256 = "sha256-B5aO6pec+Cpxelv7+Mlt1FWjLGwsQCXI0thjCMpXqeE=";
                                };
                              });
                          };
                        };
                      };
                  };
              })
            ])
            .callPackage "${config.ihaskell}/nix/release.nix" {
              compiler = config.haskellCompiler;
            };
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
