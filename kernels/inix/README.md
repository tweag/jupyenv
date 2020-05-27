# JupyterWith Nix

The Nix kernel can be used as follows:

```nix
{
iNix = jupyter.kernels.iNixKernel {
    # Identifier that will appear on the Jupyter interface.
    name = "Nix-kernel";
  };
}
```
