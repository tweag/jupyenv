# JupyterWith OCaml

Example usage:

```nix
{
  OCamlKernel = jupyter.kernels.ocamlWith {
    # Name that will appear in the Jupyter interface
    name = "OCaml kernel";
    # Extra packages that can be used by the kernel and imported crates
    packages = with pkgs; [ 
      # TODO: add extra packages example
     ];
  };
}
```
