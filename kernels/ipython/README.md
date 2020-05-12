# JupyterWith IPython

The IPython kernel can be used as follows:

```nix
{
  iPython = iPythonWith {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
    # Libraries to be available to the kernel.
    packages = p: with p; [ numpy pandas ];
    # Optional definition of `python3` to be used.
    # Useful for overlaying packages.
    python3 = pkgs.python3Packages;
    # Optional value to true that ignore file collisions inside the packages environment
    ignoreCollisions = false;
  };
}
```
