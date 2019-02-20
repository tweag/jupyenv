# JupyterWith Ansible Kernel

The Ansible kernel can be used as follows:

```nix
{
  kernel = ansibleKernel {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
  };
}
```
