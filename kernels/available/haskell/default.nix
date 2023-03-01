{
  self,
  system,
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "haskell",
  displayName ? "Haskell",
  requiredRuntimePackages ? [pkgs.haskell.compiler.${haskellCompiler}],
  runtimePackages ? [],
  haskellKernelPkg ? import "${self.inputs.ihaskell}/release.nix",
  haskellCompiler ? "ghc902",
  extraHaskellFlags ? "-M3g -N2",
  extraHaskellPackages ? (_: []),
}: let
  allRuntimePackages = requiredRuntimePackages ++ runtimePackages;

  patchedIhaskell = pkgs.runCommand "pathc" {} ''
    cp -r ${self.inputs.ihaskell} $out
    chmod -R +w $out
    sed -i -e 's/ghc-options: -threaded -rtsopts -Wall/ghc-options: -threaded -rtsopts -Wall -dynamic/g' $out/ihaskell.cabal
  '';

  env = import "${patchedIhaskell}/release.nix" {
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
  argv = kernelspec.argv;
  codemirrorMode = "haskell";
  logo64 = ./logo64.png;
}
