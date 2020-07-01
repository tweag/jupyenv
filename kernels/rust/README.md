# JupyterWith Rust

Example usage:

```nix
{
  RustKernel = jupyter.kernels.rust {
    # Name that will appear in the Jupyter interface
    name = "Rust kernel";
    # Extra packages that can be used by the kernel and imported crates
    packages = with pkgs; [ openssl pkgconfig ];
  };
}
```
