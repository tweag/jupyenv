final: prev: let
  addNativeBuildInputs = drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };
in
  {
    nix-kernel = prev.nix-kernel.overridePythonAttrs (old: {
      postPatch = ''
        # remove custom install
        sed -i "s/cmdclass={'install': install_with_kernelspec},//" setup.py
      '';
    });
  }
  // addNativeBuildInputs "jsonschema" [final.hatchling final.hatch-vcs]
  // addNativeBuildInputs "traitlets" [final.hatchling]
  // addNativeBuildInputs "terminado" [final.hatchling]
  // addNativeBuildInputs "jupyter-client" [final.hatchling]
  // addNativeBuildInputs "ipykernel" [final.hatchling]
