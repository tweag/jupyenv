# JupyterWith Gophernotes Go Kernel

The `gophernotes` kernel can be used as follows:

```nix
{
  kernel = gophernotes {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
  };
}
```
