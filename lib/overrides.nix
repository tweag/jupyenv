pkgs: let
  addNativeBuildInputs = prev: drvName: inputs: {
    "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
    });
  };

  preOverlay = final: prev: {
    y-py = prev.y-py.override {
      preferWheel = true;
    };
  };

  postOverlay = final: prev:
    {}
    // {
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
    }
    // addNativeBuildInputs prev "rfc3986-validator" [final.setuptools final.pytest-runner]
    // addNativeBuildInputs prev "jupyter-server-terminals" [final.hatchling]
    // addNativeBuildInputs prev "jupyter-events" [final.hatchling]
    // addNativeBuildInputs prev "jupyter-server-fileid" [final.hatchling]
    // addNativeBuildInputs prev "jupyter-server" [final.hatchling final.hatch-jupyter-builder]
    // addNativeBuildInputs prev "jupyter-server-ydoc" [final.hatchling]
    // addNativeBuildInputs prev "ypy-websocket" [final.hatchling]
    // addNativeBuildInputs prev "pathspec" [final.flit-core]
    // addNativeBuildInputs prev "jupyter-ydoc" [final.hatchling];
in [preOverlay pkgs.poetry2nix.defaultPoetryOverrides postOverlay]
