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
  // addNativeBuildInputs "markupsafe" [final.setuptools]
  // addNativeBuildInputs "certifi" [final.setuptools]
  // addNativeBuildInputs "charset-normalizer" [final.setuptools]
  // addNativeBuildInputs "click" [final.setuptools]
  // addNativeBuildInputs "mergedeep" [final.setuptools]
  // addNativeBuildInputs "editables" [final.setuptools]
  // addNativeBuildInputs "markdown" [final.setuptools]
  // addNativeBuildInputs "pathspec" [final.setuptools]
  // addNativeBuildInputs "jinja2" [final.setuptools]
  // addNativeBuildInputs "six" [final.setuptools]
  // addNativeBuildInputs "pluggy" [final.setuptools]
  // addNativeBuildInputs "pyyaml" [final.setuptools]
  // addNativeBuildInputs "pygments" [final.setuptools]
  // addNativeBuildInputs "packaging" [final.setuptools]
  // addNativeBuildInputs "urllib3" [final.setuptools]
  // addNativeBuildInputs "watchdog" [final.setuptools]
  // addNativeBuildInputs "dateutil" [final.setuptools]
