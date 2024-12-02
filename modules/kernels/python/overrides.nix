pkgs: let
  pypkgs-build-requirements = {
    # pdm = ["pdm-backend"];
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
      scikit-build-core = prev.scikit-build-core.overridePythonAttrs (old: rec {
        version = "0.10.7";
        src = prev.pkgs.fetchFromGitHub {
          owner = "scikit-build";
          repo = "scikit-build-core";
          rev = "refs/tags/v${version}";
          sha256 = "sha256-R6/Y9brIYBA1P3YeG8zGaoPcxWFUDqZlqbZpWu3MIIw=";
        };
      });
      cython = prev.cython.overridePythonAttrs (old: rec {
        version = "3.0.11-1";
        src = prev.pkgs.fetchFromGitHub {
          owner = "cython";
          repo = "cython";
          rev = "refs/tags/${version}";
          sha256 = "sha256-P2k21uNC6X+R6a1dWAIspGnUc6JwAzRXUleVfZG+vqY=";
        };
        patches = [];
      });
      pyzmq = prev.pyzmq.overridePythonAttrs (old: {
        buildInputs =
          (old.buildInputs or [])
          ++ [
            final.scikit-build-core
            final.pyproject-metadata
            final.pathspec
          ];
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
    });
in [overlay]
