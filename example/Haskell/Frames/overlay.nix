_: pkgs:
let
  dontCheck = pkgs.haskell.lib.dontCheck;
  overrides = _: hspkgs: {
      vinyl_0_10_0 = hspkgs.vinyl_0_10_0_1;
      singletons = dontCheck (hspkgs.callHackage "singletons" "2.4.1" {});
      th-desugar = hspkgs.callHackage "th-desugar" "1.8" {};
  };
in
{
  haskellPackages = pkgs.haskellPackages.override (old: {
    overrides =
      pkgs.lib.composeExtensions
        (old.overrides or (_:_: {}))
        overrides;
  });
}
