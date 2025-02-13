pkgs: let
  pypkgs-build-requirements = {
    pdm = ["pdm-backend"];
    webcolors = ["pdm-backend"];
    dep-logic = ["pdm-backend"];
    findpython = ["pdm-backend"];
    pbs-installer = ["pdm-backend"];
    unearth = ["pdm-backend"];
    hishel = ["hatch-fancy-pypi-readme"];
  };
  overlay = pkgs.poetry2nix.defaultPoetryOverrides.extend (final: prev:
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
      rpds-py = prev.rpds-py.overridePythonAttrs (old: {
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit (old) src;
          name = "${old.pname}-${old.version}";
          hash = "sha256-2skrDC80g0EKvTEeBI4t4LD7ZXb6jp2Gw+owKFrkZzc=";
        };
      });
    });
in [overlay]
