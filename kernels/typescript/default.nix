{
  self,
  pkgs,
  nodeenv ? pkgs.python3Packages.nodeenv,
  globalBuildInputs ? [],
}: let
  inherit (pkgs) fetchurl lib stdenv writeScriptBin;
  inherit (lib) makeBinPath;

  tslab = import ./composition.nix {inherit pkgs;};

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

    env = tslabSh;
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
