final: prev: let
  addNativeBuildInputs = drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };
in
  {
    ansible-kernel = prev.ansible-kernel.overridePythonAttrs (old: {
      postPatch = ''
        # remove when merged
        # https://github.com/ansible/ansible-jupyter-kernel/pull/82
        touch LICENSE.md

        # remove custom install
        sed -i "s/cmdclass={'install': Installer},//" setup.py
      '';
    });
  }
  // addNativeBuildInputs "jsonschema" [final.hatchling final.hatch-vcs]
  // addNativeBuildInputs "traitlets" [final.hatchling]
  // addNativeBuildInputs "terminado" [final.hatchling]
  // addNativeBuildInputs "jupyter-client" [final.hatchling]
  // addNativeBuildInputs "ipykernel" [final.hatchling]
