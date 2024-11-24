pkgs: let
  addNativeBuildInputs = prev: drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };

  preOverlay = final: prev: {
    arrow = prev.arrow.override {
      preferWheel = true;
    };
  };

  postOverlay = final: prev: {};
in [preOverlay pkgs.poetry2nix.defaultPoetryOverrides postOverlay]
