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
  };

  postOverlay = final: prev:
    {}
    // {
      babel = prev.babel_;
      Babel = prev.babel_;
      testbook = prev.testbook.overridePythonAttrs (old: {
        postPatch = ''
          mkdir ./tmp
          ${pkgs.unzip}/bin/unzip dist/testbook-${old.version}-py3-none-any.whl -d ./tmp
          sed -i -e "s|if not any(arg.startswith('--Kernel|if False and not any(arg.startswith('--Kernel|" tmp/testbook/client.py
          rm dist/testbook-${old.version}-py3-none-any.whl
          pushd tmp
            ${pkgs.zip}/bin/zip -r ../dist/testbook-${old.version}-py3-none-any.whl ./*
          popd
          rm -rf tmp
        '';
      });
    };
in
  [((pkgs.poetry2nix.defaultPoetryOverrides.overrideOverlay preOverlay).extend postOverlay)]
