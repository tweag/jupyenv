pkgs: let
  preOverlay = final: prev: {
    arrow = prev.arrow.override {
      preferWheel = true;
    };
    pyzmq = prev.pyzmq.overridePythonAttrs (old: {
      nativeBuildInputs =
        old.nativeBuildInputs
        or []
        ++ [
          pkgs.which
        ];
      patchPhase = ''
        export PATH="$PATH:${pkgs.cmake}/bin"
      '';
    });
  };
  pypkgs-build-requirements = {
    pdm = ["pdm-backend"];
    webcolors = ["pdm-backend"];
    dep-logic = ["pdm-backend"];
    findpython = ["pdm-backend"];
    pbs-installer = ["pdm-backend"];
    unearth = ["pdm-backend"];
    hishel = ["hatch-fancy-pypi-readme"];
    jinja2 = ["flit-core"];
    pyzmq = ["scikit-build-core"];
    urllib3 = ["hatchling" "hatch-vcs"];
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
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit (old) src;
          name = "${old.pname}-${old.version}";
          hash = "sha256-VOmMNEdKHrPKJzs+D735Y52y47MubPwLlfkvB7Glh14=";
        };
      });
      rfc3986-validator = prev.rfc3986-validator.overridePythonAttrs (old: {
        nativeBuildInputs = (old.buildInputs or []) ++ [prev.setuptools prev.wheel pkgs.patchutils];
        patchPhase = ''
          # Patch setup.py to remove pytest-runner
          substituteInPlace setup.py \
            --replace-fail "setup_requirements = ['pytest-runner', ]" "setup_requirements = []" \
        '';
        buildPhase = ''
          python setup.py sdist bdist_wheel
        '';
      });
      tinycss2 = prev.tinycss2.overridePythonAttrs (old: {
        buildInputs = [];
      });
    };
in [preOverlay pkgs.poetry2nix.defaultPoetryOverrides postOverlay]
