# JupyterWith Bash Kernel

The Bash kernel can be used as follows:

```nix
{
  kernel = bashKernel {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
  };
}
```
