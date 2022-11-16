{
  self,
  pkgs,
  name ? "haskell",
  displayName ? "Haskell",
  haskellKernelPkg ? pkgs.ihaskellPkgs,
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
