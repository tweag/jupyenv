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

  postOverlay = final: prev:
    {}
    // {
      pdm = prev.pdm.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or []) ++ [prev.pdm-backend];
        }
      );
      webcolors = prev.webcolors.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or []) ++ [prev.pdm-backend];
        }
      );
      dep-logic = prev.dep-logic.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or []) ++ [prev.pdm-pep517 prev.pdm-backend];
        }
      );
      findpython = prev.findpython.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or []) ++ [prev.pdm-pep517 prev.pdm-backend];
        }
      );
      pbs-installer = prev.pbs-installer.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or []) ++ [prev.pdm-pep517 prev.pdm-backend];
        }
      );
      rpds-py = prev.rpds-py.overridePythonAttrs (old: {
        cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
          inherit (old) src;
          name = "${old.pname}-${old.version}";
          hash = "sha256-VOmMNEdKHrPKJzs+D735Y52y47MubPwLlfkvB7Glh14=";
        };
      });
      unearth = prev.unearth.overridePythonAttrs (
        old: {
          buildInputs = (old.buildInputs or []) ++ [prev.pdm-pep517 prev.pdm-backend];
        }
      );
      hishel = prev.hishel.overridePythonAttrs (
        old: {
          buildInputs =
            (old.buildInputs or [])
            ++ [
              prev.hatch-fancy-pypi-readme
            ];
        }
      );
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
in [preOverlay pkgs.poetry2nix.defaultPoetryOverrides postOverlay]
