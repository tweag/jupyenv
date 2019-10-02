_: pkgs:

let
  ihaskellSrc = pkgs.fetchFromGitHub {
    owner = "gibiansky";
    repo = "IHaskell";
    rev = "c070adf8828dad378bb0048483c16f2640a339b5";
    sha256 = "1v8hvr75lg3353qgm18k43b3wl040zkbhkklw6ygv5w8zzb3x826";
  };

  overrides = self: hspkgs:
    let
      callDisplayPackage = name:
        hspkgs.callCabal2nix
          "ihaskell-${name}"
          "${ihaskellSrc}/ihaskell-display/ihaskell-${name}"
          {};
      dontCheck = pkgs.haskell.lib.dontCheck;
    in
    {
      # -- ihaskell overrides
      # the current version of hlint in nixpkgs uses a different
      # version of haskell-src-exts, which creates incompatibilities
      # when building ihaskell
      hlint = hspkgs.callHackage "hlint" "2.1.11" {};
      zeromq4-haskell = dontCheck hspkgs.zeromq4-haskell;
      ihaskell = pkgs.haskell.lib.overrideCabal
        (hspkgs.callCabal2nix "ihaskell" ihaskellSrc {})
        (_drv: {
          preCheck = ''
            export HOME=$(${pkgs.pkgs.coreutils}/bin/mktemp -d)
            export PATH=$PWD/dist/build/ihaskell:$PATH
            export GHC_PACKAGE_PATH=$PWD/dist/package.conf.inplace/:$GHC_PACKAGE_PATH
          '';
          configureFlags = (_drv.configureFlags or []) ++ [
            # otherwise the tests are agonisingly slow and the kernel times out
            "--enable-executable-dynamic"
          ];
          doHaddock = false;
         });
      ghc-parser = hspkgs.callCabal2nix "ghc-parser" "${ihaskellSrc}/ghc-parser" {};
      ipython-kernel = hspkgs.callCabal2nix "ipython-kernel" "${ihaskellSrc}/ipython-kernel" {};
      ihaskell-aeson = callDisplayPackage "aeson";
      ihaskell-blaze = callDisplayPackage "blaze";
      ihaskell-charts = callDisplayPackage "charts";
      ihaskell-diagrams = callDisplayPackage "diagrams";
      ihaskell-gnuplot = callDisplayPackage "gnuplot";
      ihaskell-graphviz = callDisplayPackage "graphviz";
      ihaskell-hatex = callDisplayPackage "hatex";
      ihaskell-juicypixels = callDisplayPackage "juicypixels";
      ihaskell-magic = callDisplayPackage "magic";
      ihaskell-plot = callDisplayPackage "plot";
      ihaskell-rlangqq = callDisplayPackage "rlangqq";
      ihaskell-static-canvas = callDisplayPackage "static-canvas";
      ihaskell-widgets = callDisplayPackage "widgets";

      megaparsec = hspkgs.megaparsec_6_5_0;

      # missing dependency
      aeson = pkgs.haskell.lib.addBuildDepends hspkgs.aeson [ self.contravariant ];
    };
in

{
  haskellPackages = pkgs.haskell.packages.ghc844.override (old: {
    overrides =
      pkgs.lib.composeExtensions
        (old.overrides or (_: _: {}))
        overrides;
  });
}
