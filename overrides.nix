final: prev: let
  addNativeBuildInputs = drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };
in
  {}
  // addNativeBuildInputs "jsonschema" [final.hatchling final.hatch-vcs]
  // addNativeBuildInputs "traitlets" [final.hatchling]
  // addNativeBuildInputs "terminado" [final.hatchling]
  // addNativeBuildInputs "jupyter-client" [final.hatchling]
  // addNativeBuildInputs "jupyter-server" [final.hatchling]
  // addNativeBuildInputs "jupyterlab-server" [final.hatchling]
  // addNativeBuildInputs "ipykernel" [final.hatchling]
