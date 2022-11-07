{
  self,
  pkgs,
  name ? "scala",
  displayName ? "Scala",
  runtimePackages ? [],
  extraRuntimePackages ? [],
  scala ? pkgs.scala,
  coursier ? pkgs.coursier,
  jdk ? pkgs.jdk,
  jre ? pkgs.jre,
}: let
  inherit (pkgs) lib makeWrapper stdenv;

  allRuntimePackages = runtimePackages ++ extraRuntimePackages;

  almondSh = let
    baseName = "almond";
    version = "0.13.1";
    scalaVersion = pkgs.scala.version;
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
      outputHash = "iPWMAvEW83aETWrxt9CmBAYMNouWsHHDoEa+Qy9inyE=";
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
}
