{
  self,
  system,
  config,
  lib,
  mkKernel,
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
    kernelFunc = {
      self,
      system,
      # custom arguments
      pkgs,
      rust-overlay ? self.inputs.rust-overlay,
      name ? "rust",
      displayName ? "Rust",
      requiredRuntimePackages ? with pkgs; [cargo gcc binutils-unwrapped],
      runtimePackages ? [],
      evcxr ? pkgs.evcxr,
    }: let
      /*
      rust-overlay recommends using `default` over `rust`.
      Pre-aggregated package `rust` is not encouraged for stable channel since it
      contains almost all and uncertain components.
      https://github.com/oxalica/rust-overlay/blob/1558464ab660ddcb45a4a4a691f0004fdb06a5ee/rust-overlay.nix#L331
      */
      rust = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src"];
      };

      allRuntimePackages = requiredRuntimePackages ++ runtimePackages ++ [rust];

      env = evcxr;
      wrappedEnv =
        pkgs.runCommand "wrapper-${env.name}"
        {nativeBuildInputs = [pkgs.makeWrapper];}
        ''
          mkdir -p $out/bin
          for i in ${env}/bin/*; do
            filename=$(basename $i)
            ln -s ${env}/bin/$filename $out/bin/$filename
            wrapProgram $out/bin/$filename \
              --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}" \
              --set RUST_SRC_PATH "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}"
          done
        '';
    in {
      inherit name displayName;
      language = "rust";
      argv = [
        "${wrappedEnv}/bin/evcxr_jupyter"
        "--control_file"
        "{connection_file}"
      ];
      codemirrorMode = "rust";
      logo64 = ./logo-64x64.png;
      logo32 = ./logo32.png;
    };
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
      build = mkKernel (kernelFunc config.kernelArgs);
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
