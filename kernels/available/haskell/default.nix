{
  self,
  system,
  pkgs ? self.inputs.nixpkgs.legacyPackages.${system},
  name ? "haskell",
  displayName ? "Haskell",
  haskellKernelPkg ? import "${self.inputs.ihaskell}/release.nix",
  haskellCompiler ? "ghc902",
  extraHaskellFlags ? "-M3g -N2",
  extraHaskellPackages ? (_: []),
}: let
  env = haskellKernelPkg {
    compiler = haskellCompiler;
    nixpkgs = pkgs;
    packages = extraHaskellPackages;
  };
  kernelspec =
    env.ihaskellKernelFileFunc
    (env.ihaskellGhcLibFunc env.ihaskellExe env.ihaskellEnv)
    extraHaskellFlags;
in {
  inherit name displayName;
  language = "haskell";
  argv = kernelspec.argv;
  codemirrorMode = "haskell";
  logo64 = ./logo64.png;
}
