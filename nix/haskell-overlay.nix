_: pkgs:

let
  ihaskellSrc = pkgs.fetchFromGitHub {
    owner = "gibiansky";
    repo = "IHaskell";
    rev = "c070adf8828dad378bb0048483c16f2640a339b5";
    sha256 = "1v8hvr75lg3353qgm18k43b3wl040zkbhkklw6ygv5w8zzb3x826";
  };

  dataHaskellCoreSrc = pkgs.fetchFromGitHub {
    owner = "DataHaskell";
    repo = "dh-core";
    rev = "3fd4d8d62e12452745dc484459d1a5874f523df9";
    sha256 = "12z0jfhwpvk5gd1wckasy346aqm0280pv5h7jl1grpk797zjdswx";
  };
in

{
  haskellPackages = pkgs.haskell.packages.ghc844.override {
    overrides = _: hspkgs:
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
        ihaskell          = pkgs.haskell.lib.overrideCabal (
                             hspkgs.callCabal2nix "ihaskell" ihaskellSrc {}) (_drv: {
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

        # -- dh-core integration
        # the new datasets module from dh-core doesn't build because one of the
        # dependencies doesn't build due to a missing dependency. We therefore
        # use the one that comes with nixpkgs (vs 0.2.5) for now
        # datasets = hspkgs.callCabal2nix "datasets" "${dataHaskellCoreSrc}/datasets" {};
        dh-core = hspkgs.callCabal2nix "dh-core" "${dataHaskellCoreSrc}/dh-core" {};
        analyze = hspkgs.callCabal2nix "analyze" "${dataHaskellCoreSrc}/analyze" {};

        # -- for Frames
        vinyl_0_10_0 = hspkgs.vinyl_0_10_0_1;

        # -- for funflow
        funflow = pkgs.haskell.lib.dontCheck hspkgs.funflow;
      };
  };
}
