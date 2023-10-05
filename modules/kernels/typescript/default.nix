{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "typescript";
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
      name ? "typescript",
      displayName ? "TypeScript",
      requiredRuntimePackages ? [],
      runtimePackages ? [],
      npmlock2nix ? self.inputs.npmlock2nix,
    }: let
      inherit (pkgs) lib stdenv writeScriptBin;
      inherit (lib) makeBinPath;

      pkgs' = import pkgs.path {
        inherit system;
        config.permittedInsecurePackages = [
          "nodejs-14.21.3"
          "openssl-1.1.1w"
        ];
      };
      _npmlock2nix = pkgs'.callPackage npmlock2nix {};

      version = "1.0.15";

      tslabSrc = fetchTarball {
        url = "https://github.com/yunabe/tslab/archive/v${version}.tar.gz";
        sha256 = "1q2wsdcgha6qivs238pysgmiabjhyflpd1bqbx0cgisgiz2nq3vs";
      };

      tslab = _npmlock2nix.build {
        src = tslabSrc;
        node_modules_attrs.packageLockJson = ./package-lock.json;
        buildInputs = [pkgs.makeWrapper];
        postPatch = ''
          # Change the source so it looks for the package.json file in the same
          # directory level and not the parent. The package.json file will be
          # stored in the same directory rather than the top level of the package.
          substituteInPlace src/util.ts \
            --replace "../package.json" "./package.json"

          # There is another file src/converter.ts that looks for the existence of
          # the package.json file but appears that it will fail regardless and has
          # a fallback so I do not think we need to patch this file.
        '';
        installPhase = ''
          mkdir -p $out/bin

          # Patch tslab binary so it looks for main in the correct location.
          substitute bin/tslab $out/bin/tslab \
            --replace "../dist/main.js" "../libexec/main.js"
          chmod +x $out/bin/tslab

          # Store distribution files in libexec as is standard for dependencies.
          cp -r dist $out/libexec

          # tslab needs the node modules at runtime but it is not available so we
          # link it so the distribution files can find it.
          ln -s ${tslab.node_modules}/node_modules $out/libexec/node_modules

          # Wrap tslab so it knows where to find node modules and change the
          # directory so it sees the directory.
          wrapProgram $out/bin/tslab \
            --set NODE_PATH $out/libexec/node_modules \
            --chdir $out/libexec

          # Copy the package.json to the same directory as the distribution files
          # so it can be discovered.
          cp package.json $out/libexec
        '';
      };

      allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

      env = tslab;
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

      # Same as with the javascript kernel
      # testbook adds a --Kernel argument breaking the javascript kernel
      # https://github.com/nteract/testbook/blob/f6692b41e761addd65497df229b1e75532bdc9c6/testbook/client.py#L29-L30
      tslabSh = writeScriptBin "tslab" ''
        #! ${stdenv.shell}
        if [[ ''${@: -1} == --Kernel* ]] ; then
          ${wrappedEnv}/bin/tslab "''${@:1:$#-1}"
        else
          ${wrappedEnv}/bin/tslab "$@"
        fi
      '';
    in {
      inherit name displayName;
      language = "typescript";
      argv = [
        "${tslabSh}/bin/tslab"
        "kernel"
        "--config-path"
        "{connection_file}"
      ];
      codemirrorMode = "typescript";
      logo64 = ./logo-64x64.png;
    };
  in {
    options =
      {
        npmlock2nix = lib.mkOption {
          type = types.path;
          default = self.inputs.npmlock2nix;
          defaultText = lib.literalExpression "self.inputs.npmlock2nix";
          example = lib.literalExpression "self.inputs.npmlock2nix";
          description = lib.mdDoc ''
            npmlock2nix flake input to be used to build this ${kernelName} kernel.
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        {
          inherit (config) npmlock2nix;
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
