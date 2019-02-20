# JupyterWith IHaskell

The IHaskell kernel can be used as follows:

```nix
{
  iHaskell = iHaskellWith {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
    # Libraries to be available to the kernel.
    packages = p: with p; [ vector aeson ];
    # Optional definition of `haskellPackages` to be used.
    # Useful for overlaying packages.
    haskellPackages = pkgs.haskellPackages;
  };
}
```
