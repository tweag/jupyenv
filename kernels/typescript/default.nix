{
  self,
  pkgs,
  npmlock2nix ? pkgs.npmlock2nix,
}: let
  inherit (pkgs) lib stdenv writeScriptBin;
  inherit (lib) makeBinPath;

  tslabSrc = fetchTarball {
    url = "https://github.com/yunabe/tslab/archive/f056a88baf81a1fc6a01b0446a3febcf919ff8e4.tar.gz";
    sha256 = "1q2wsdcgha6qivs238pysgmiabjhyflpd1bqbx0cgisgiz2nq3vs";
  };

  tslab = pkgs.npmlock2nix.build {
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

      # Wrap tslab so it knows where to find node modules.
      wrapProgram $out/bin/tslab \
        --set NODE_PATH $out/libexec/node_modules \
        --chdir $out/libexec

      # tslab needs the node modules available during runtime.
      ln -s ${tslab.node_modules}/node_modules $out/libexec/node_modules

      # Copy the package.json to the same directory as the distribution files
      # so it can be discovered.
      cp package.json $out/libexec
    '';
  };
in
  {
    name ? "typescript",
    displayName ? "Typescript", # TODO: add version
    language ? "typescript",
    argv ? null,
    codemirrorMode ? "typescript",
    logo64 ? ./logo64.png,
    runtimePackages ? [],
    extraRuntimePackages ? [],
  }: let
    allRuntimePackages = runtimePackages ++ extraRuntimePackages;

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

    argv_ =
      if argv == null
      then [
        "${wrappedEnv}/bin/tslab"
        "kernel"
        "--config-path"
        "{connection_file}"
      ]
      else argv;
  in {
    argv = argv_;
    inherit
      name
      displayName
      language
      codemirrorMode
      logo64
      ;
  }
