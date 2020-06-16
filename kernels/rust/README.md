# JupyterWith Rust

Example usage:

```nix
{
  rustEnv = pkgs.symlinkJoin {
    name = "rust-env";
    buildInputs = [ pkgs.makeWrapper ];
    paths = with pkgs; [
      evcxr
    ];

    # Some packages fail to build unless binutils-unwrapped is in scope,
    # because they require the 'ar' tool
    postBuild = ''
      wrapProgram $out/bin/evcxr_jupyter \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.binutils-unwrapped pkgs.gcc pkgs.cargo ]}
    '';
  };

  RustKernel = jupyter.kernels.rust {
    evcxr = rustEnv;
  };
}
```
