pkgs: let
  addNativeBuildInputs = prev: drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };

  # A fix is on the way soon, https://github.com/nix-community/poetry2nix/pull/787
  preOverlay = final: prev: {
    babel = null;
    Babel = null;
    babel_ = prev.babel.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [final.setuptools];
    });
    pillow_ = prev.pillow;
    matplotlib_ = prev.matplotlib;
  };

  postOverlay = final: prev:
    {}
    // {
      babel = prev.babel_;
      Babel = prev.babel_;
      pillow = prev.pillow_;
      matplotlib = prev.matplotlib_;
    };
in
  (pkgs.poetry2nix.defaultPoetryOverrides.overrideOverlay preOverlay).extend postOverlay
