ihaskell: final: prev: {
  haskellPackages = prev.haskellPackages.override (old: {
    overrides =
      prev.lib.composeExtensions
      (old.overrides or (_: _: {}))
      ihaskell.packages."${prev.system}".ihaskell-env.ihaskellOverlay;
  });
}
