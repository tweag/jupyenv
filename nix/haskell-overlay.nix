final: prev:

let
  ihaskellSrc = prev.fetchFromGitHub {
    owner = "gibiansky";
    repo = "IHaskell";
    rev = "4e1a2a132c165e1669faaeac355eb853e1f628a3";
    sha256 = "TpzbTT2D5wBTrv1ML+twp34c5KuV1FInvfZXPo48B4o=";
  };

  overrides = self: hspkgs:
    let
      callDisplayPackage = name:
        hspkgs.callCabal2nix
          "ihaskell-${name}"
          "${ihaskellSrc}/ihaskell-display/ihaskell-${name}"
          {};
      dontCheck = prev.haskell.lib.dontCheck;
      dontHaddock = prev.haskell.lib.dontHaddock;
    in
    {
      ihaskell = prev.haskell.lib.overrideCabal
        (hspkgs.callCabal2nix "ihaskell" ihaskellSrc {})
        (_drv: {
          preCheck = ''
            export HOME=$(${prev.pkgs.coreutils}/bin/mktemp -d)
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

      # Marked as broken in this version of Nixpkgs.
      #chell = hspkgs.callHackage "chell" "0.4.0.2" {};
      #patience = hspkgs.callHackage "patience" "0.1.1" {};

      # Tests not passing.
      #Diff = dontCheck hspkgs.Diff;
      #zeromq4-haskell = dontCheck hspkgs.zeromq4-haskell;

    };
in

{
  haskellPackages = prev.haskellPackages.override (old: {
    overrides =
      prev.lib.composeExtensions
        (old.overrides or (_: _: {}))
        overrides;
  });
}
