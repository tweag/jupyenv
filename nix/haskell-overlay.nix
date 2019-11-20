_: pkgs:

let
  ihaskellSrc = pkgs.fetchFromGitHub {
    owner = "gibiansky";
    repo = "IHaskell";
    rev = "e15dd63d2efdcfda599dc022732b33589005a6d5";
    sha256 = "1p2j7jlygvnw7gpgl28fv5yh6cl87s5pk080i6vk5r0ipx3yjmqj";
  };

  overrides = self: hspkgs:
    let
      callDisplayPackage = name:
        hspkgs.callCabal2nix
          "ihaskell-${name}"
          "${ihaskellSrc}/ihaskell-display/ihaskell-${name}"
          {};
      dontCheck = pkgs.haskell.lib.dontCheck;
      dontHaddock = pkgs.haskell.lib.dontHaddock;
    in
    {
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

      # Marked as broken in this version of Nixpkgs.
      chell = hspkgs.callHackage "chell" "0.4.0.2" {};
      patience = hspkgs.callHackage "patience" "0.1.1" {};

      # Version compatible with ghc-lib-parser.
      hlint = hspkgs.callHackage "hlint" "2.2.1" {};

      # Tests not passing.
      Diff = dontCheck hspkgs.Diff;
      zeromq4-haskell = dontCheck hspkgs.zeromq4-haskell;

      # Haddocks not building.
      ghc-lib-parser = dontHaddock hspkgs.ghc-lib-parser;

      # Missing dependency.
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
