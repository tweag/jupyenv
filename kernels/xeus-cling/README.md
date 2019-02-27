# JupyterWith Xeus Cling C++ Kernel

The `xeus-cling` kernel can be used as follows:

```nix
{
  kernel = xeusCling {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
  };
}
```
