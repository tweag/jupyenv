self: super:

let
  ihaskellSrc = super.fetchFromGitHub {
    owner = "gibiansky";
    repo = "IHaskell";
    rev = "376d108d1f034f4e9067f8d9e9ef7ddad2cce191";
    sha256 = "0359rn46xaspzh96sspjwklazk4qljdw2xxchlw2jmfa173miq6a";
  };

in

{
  haskellPackages = super.haskellPackages.override {
    overrides = selfHS: superHS:
      let
        mkDisplay = name:
          superHS.callCabal2nix "ihaskell-${name}" "${ihaskellSrc}/ihaskell-display/ihaskell-${name}" {};
      in
      {
        zeromq4-haskell = super.haskell.lib.dontCheck superHS.zeromq4-haskell;
        ihaskell = superHS.callCabal2nix "ihaskell" ihaskellSrc {};
        ihaskell-aeson = mkDisplay "aeson";
        ihaskell-blaze = mkDisplay "blaze";
        ihaskell-charts = mkDisplay "charts";
        ihaskell-diagrams = mkDisplay "diagrams";
        ihaskell-gnuplot = mkDisplay "gnuplot";
        ihaskell-graphviz = mkDisplay "graphviz";
        ihaskell-hatex = mkDisplay "hatex";
        ihaskell-juicypixels = mkDisplay "juicypixels";
        ihaskell-magic = mkDisplay "magic";
        ihaskell-plot = mkDisplay "plot";
        ihaskell-rlangqq = mkDisplay "rlangqq";
        ihaskell-static-canvas = mkDisplay "static-canvas";
        ihaskell-widgets = mkDisplay "widgets";
      };
  };
}
