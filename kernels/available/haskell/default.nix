{
  pkgs,
  name,
  displayName ? "Haskell",
  requiredRuntimePackages,
  runtimePackages,
  haskellKernelPkg,
  haskellCompiler,
  extraHaskellFlags,
  extraHaskellPackages,
}: let
  allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

  env = haskellKernelPkg {
    compiler = haskellCompiler;
    nixpkgs = pkgs;
    packages = extraHaskellPackages;
  };

  kernelspec = let
    ihaskellGhcLib = env.ihaskellGhcLibFunc env.ihaskellExe env.ihaskellEnv;
    wrappedEnv =
      pkgs.runCommand "wrapper-${ihaskellGhcLib.name}"
      {nativeBuildInputs = [pkgs.makeWrapper];}
      ''
        mkdir -p $out/bin
        for i in ${ihaskellGhcLib}/bin/*; do
          filename=$(basename $i)
          ln -s ${ihaskellGhcLib}/bin/$filename $out/bin/$filename
          wrapProgram $out/bin/$filename \
            --set PATH "${pkgs.lib.makeSearchPath "bin" allRuntimePackages}"
        done
      '';
  in
    env.ihaskellKernelFileFunc
    wrappedEnv
    extraHaskellFlags;
in {
  inherit name displayName;
  language = "haskell";
  # See https://github.com/IHaskell/IHaskell/pull/1191
  argv = kernelspec.argv ++ ["--codemirror" "Haskell"];
  codemirrorMode = "Haskell";
  logo64 = ./logo64.png;
}
