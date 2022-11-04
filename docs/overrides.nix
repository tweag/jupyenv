final: prev: let
  addNativeBuildInputs = drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };
in
  {}
  // addNativeBuildInputs "idna" [final.flit-core]
  // addNativeBuildInputs "pyparsing" [final.flit-core]
  // addNativeBuildInputs "tomli" [final.flit-core]
  // addNativeBuildInputs "mkdocs-material-extensions" [final.hatchling]
  // addNativeBuildInputs "pymdown-extensions" [final.hatchling]
  // addNativeBuildInputs "pyyaml-env-tag" [final.flit-core]
  // addNativeBuildInputs "mkdocs" [final.hatchling]
