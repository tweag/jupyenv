{
  self,
  system,
  config,
  lib,
  mkKernel,
  ...
}: let
  inherit (lib) types;

  kernelName = "scala";
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
      name ? "scala",
      displayName ? "Scala",
      requiredRuntimePackages ? [],
      runtimePackages ? [],
      scala ? pkgs.scala,
      coursier ? pkgs.coursier,
      jdk ? pkgs.jdk,
      jre ? pkgs.jre,
    }: let
      inherit (pkgs) lib makeWrapper stdenv;

      allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

      almondSh = let
        baseName = "almond";
        version = "0.14.0-RC7";
        scalaVersion = scala.version;
        deps = stdenv.mkDerivation {
          name = "${baseName}-deps-${version}";

          buildCommand = ''
            export COURSIER_CACHE=$(pwd)
            ${coursier}/bin/cs fetch -r jitpack sh.almond:scala-kernel_${scalaVersion}:${version} > deps
            mkdir -p $out/share/java
            cp $(< deps) $out/share/java/
          '';

          outputHashMode = "recursive";
          outputHashAlgo = "sha256";
          outputHash = "sha256-JIYAuhV3+PQBceGEIgn5DkHTG80cKNV11FeJTefRHi8=";
        };
      in
        stdenv.mkDerivation {
          pname = baseName;
          inherit version;
          inherit scalaVersion;

          nativeBuildInputs = [makeWrapper];
          buildInputs = [jdk deps];

          dontUnpack = true;

          installPhase = ''
            runHook preInstall
            makeWrapper ${jre}/bin/java $out/bin/${baseName} \
              --add-flags "-cp $CLASSPATH almond.ScalaKernel"
            runHook postInstall
          '';

          installCheckPhase = ''
            $out/bin/${baseName} --version | grep -q "${version}"
          '';

          meta = with lib; {
            description = "A Scala kernel for Jupyter";
            homepage = "https://github.com/almond-sh/almond";
            license = licenses.bsd3;
            maintainers = [maintainers.GuillaumeDesforges];
          };
        };

      env = almondSh;
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
      language = "scala";
      argv = [
        "${wrappedEnv}/bin/almond"
        "--connection-file"
        "{connection_file}"
      ];
      codemirrorMode = "scala";
      logo64 = ./logo64.png;
    };
  in {
    options =
      {
        scala = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.scala;
          example = lib.literalExpression "pkgs.scala";
          description = lib.mdDoc ''
            Scala package to use with almond.
          '';
        };

        coursier = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.coursier;
          example = lib.literalExpression "pkgs.coursier";
          description = lib.mdDoc ''
            Coursier package to use with almond.
          '';
        };

        jdk = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.jdk;
          example = lib.literalExpression "pkgs.jdk";
          description = lib.mdDoc ''
            JDK package to use with almond.
          '';
        };

        jre = lib.mkOption {
          type = types.package;
          default = config.nixpkgs.jre;
          example = lib.literalExpression "pkgs.jre";
          description = lib.mdDoc ''
            JRE package to use with almond.
          '';
        };
      }
      // kernelModule.options;
    config = lib.mkIf config.enable {
      build = mkKernel (kernelFunc config.kernelArgs);
      kernelArgs =
        {
          inherit (config) scala coursier jdk jre;
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
