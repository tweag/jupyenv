poetry2nix: let
  postOverlay = final: prev: let
    addNativeBuildInputs = drvName: inputs: {
      "${drvName}" = prev.${drvName}.overridePythonAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or []) ++ inputs;
      });
    };
    unpackSource = source:
      prev.pkgs.runCommand "orjson-src" {
        src = source;
      } ''
        mkdir -p $out
        tar -zxf $src -C $out --strip-components=1
      '';
  in {
    # newest rust deps is required to build orjson
    orjson = prev.orjson.overridePythonAttrs (old: {
      cargoDeps = with old;
        prev.pkgs.rustPlatform.importCargoLock {
          lockFile = "${unpackSource old.src}/Cargo.lock";
        };
    });
    cryptography = prev.cryptography.overridePythonAttrs (old: {
      cargoDeps = with old;
        prev.pkgs.rustPlatform.importCargoLock {
          lockFile = "${unpackSource old.src}/src/rust/Cargo.lock";
        };
    });
  };
  ## aws
  # // addNativeBuildInputs "<package>" [final.<deps>];

  preOverlay = final: prev: {
    # disable the preferWheel for a package, such as rust related packages
    wheel = prev.wheel.override {preferWheel = false;};

    cryptography = prev.cryptography.override {
      preferWheel = false;
    };
    orjson = prev.orjson.override {
      preferWheel = false;
    };
  };
in [preOverlay poetry2nix.defaultPoetryOverrides postOverlay]
