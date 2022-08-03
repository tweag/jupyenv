{
  self,
  pkgs,
  iruby ? pkgs.iruby,
  extraRubyPackages ? [],
}: let
  #  env = iruby.overrideAttrs (final: prev: {
  #    exes = prev.exes ++ extraRubyPackages;
  #  });
in
  {
    name ? "ruby",
    displayName ? "Ruby", # TODO: add version
    language ? "ruby",
    argv ? null,
    codemirrorMode ? "ruby",
    logo64 ? ./logo64.png,
    runtimePackages ? with pkgs; [czmq zeromq],
    extraRuntimePackages ? [],
  }: let
    allRuntimePackages = runtimePackages ++ extraRuntimePackages;

    env = iruby;
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
        "${wrappedEnv}/bin/iruby"
        "kernel"
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
