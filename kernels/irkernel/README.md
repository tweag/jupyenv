# JupyterWith IRkernel

The IRkernel can be used as follows:

```nix
{
  irkernel = iRWith {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
    # Libraries to be available to the kernel.
    packages = p: with p; [ p.ggplot2 ];
    # Optional definition of `rPackages` to be used.
    # Useful for overlaying packages.
    rPackages = pkgs.rPackages;
  };
}
```
