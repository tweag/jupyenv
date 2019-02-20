# JupyterWith IRuby

The IRuby kernel can be used as follows:

```nix
{
  iRuby = iRubyWith {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
    # Libraries to be available to the kernel.
    packages = p: with p; [ ];
  };
}
```
