final: prev: let
  addNativeBuildInputs = drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };
in
  {
    bash-kernel = prev.bash-kernel.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.flit-core final.ipykernel];
      postPatch = ''
        sed -i \
          -e 's|requires = \["flit"\]|requires = \["flit_core >=3.2,<4"\]|' \
          -e 's|build-backend = "flit.buildapi"|build-backend = "flit_core.buildapi"|' \
            pyproject.toml
      '';
    });
  }
  // addNativeBuildInputs "traitlets" [final.hatchling]
  // addNativeBuildInputs "jupyter-client" [final.hatchling]
  // addNativeBuildInputs "ipykernel" [final.hatchling]
