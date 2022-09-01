{
  self,
  pkgs,
  nodejs ? pkgs.nodejs-14_x,
  npmlock2nix ? pkgs.npmlock2nix,
  yarn ? pkgs.yarn,
}: let
  inherit (pkgs) lib stdenv writeScriptBin;
  inherit (lib) makeBinPath;

  tslabSrc = fetchTarball {
    url = "https://github.com/yunabe/tslab/archive/f056a88baf81a1fc6a01b0446a3febcf919ff8e4.tar.gz";
    sha256 = "1q2wsdcgha6qivs238pysgmiabjhyflpd1bqbx0cgisgiz2nq3vs";
  };

  tslab = pkgs.npmlock2nix.build {
    src = tslabSrc;
    #patches = [ ./kernels/typescript/tslab-version.patch ];
    #postPatch = ''
    #  substitute ${./kernels/typescript/tslab-version.patch} tslab-version.patch \
    #    --subst-var-by version "1.0.15"
    #  patch -p1 tslab-version.patch
    #'';
    node_modules_attrs.packageLockJson = ./package-lock.json;
    buildInputs = [pkgs.makeWrapper];
    installPhase = ''
      mkdir -p $out/bin
      cp -r dist $out/libexec
      substitute bin/tslab $out/bin/tslab \
        --replace "../dist/main.js" "../libexec/main.js"
      chmod +x $out/bin/tslab
      wrapProgram $out/bin/tslab \
        --set NODE_PATH $out/libexec/node_modules \
        --chdir $out/libexec
      ln -s ${tslab.node_modules}/node_modules $out/libexec/node_modules
      cp package.json $out # FIXME
    '';
    # buildCommands = [ "yarn build" ];
  };

  tslabSh = writeScriptBin "tslab" ''
    #! ${stdenv.shell}
    export PATH="${makeBinPath [tslab]}:$PATH"
    ${tslab}/bin/tslab "$@"
  '';
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
