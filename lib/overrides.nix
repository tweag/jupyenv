pkgs: let
  preOverlay = final: prev: {
    arrow = prev.arrow.override {
      preferWheel = true;
    };
  };
  pypkgs-build-requirements = {
    pdm = ["pdm-backend"];
    webcolors = ["pdm-backend"];
    dep-logic = ["pdm-backend"];
    findpython = ["pdm-backend"];
    pbs-installer = ["pdm-backend"];
    unearth = ["pdm-backend"];
    hishel = ["hatch-fancy-pypi-readme"];
  };
  postOverlay = final: prev:
    (builtins.mapAttrs (
        package: build-requirements:
          (builtins.getAttr package prev).overridePythonAttrs (old: {
            buildInputs =
              (old.buildInputs or [])
              ++ (builtins.map (pkg:
                if builtins.isString pkg
                then builtins.getAttr pkg prev
                else pkg)
              build-requirements);
          })
      )
      pypkgs-build-requirements)
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
      rpds-py = prev.rpds-py.overridePythonAttrs (old: {
        cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
          inherit (old) src;
          name = "${old.pname}-${old.version}";
          hash = "sha256-VOmMNEdKHrPKJzs+D735Y52y47MubPwLlfkvB7Glh14=";
        };
      });
    };
in [preOverlay pkgs.poetry2nix.defaultPoetryOverrides postOverlay]
