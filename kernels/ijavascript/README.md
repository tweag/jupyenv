# JupyterWith IJavaScript Kernel

The IJavaScript kernel can be used as follows:

```nix
{
  kernel = iJavascript {
    # Identifier that will appear on the Jupyter interface.
    name = "nixpkgs";
  };
}
```

## Development notes

In order to rebuild the Nix files:

```
node2nix -i node-packages.json
```

