{
  kernelName,
  requiredRuntimePackages ? [],
}: {
  self,
  system,
  config,
  lib,
  ...
}: let
  inherit (lib) types;

  kernelOptions = {
    config,
    name,
    ...
  }: let
    args = {inherit self system lib config name kernelName requiredRuntimePackages;};
    kernelModule = import ./kernel.nix args;
  in {
    options =
      {
        projectDir = lib.mkOption {
          type = types.path;
          default = self + "/kernels/available/${kernelName}";
          defaultText = lib.literalExpression "self + \"/kernels/available/${kernelName}\"";
          example = lib.literalExpression "self + \"/kernels/${kernelName}\"";
          description = lib.mdDoc ''
            Path to the root of the poetry project that provides this ${kernelName}
            kernel.
          '';
        };

        pyproject = lib.mkOption {
          type = types.path;
          default = config.projectDir + "/pyproject.toml";
          defaultText = lib.literalExpression "kernel.${kernelName}.<name>.projectDir + \"/pyproject.toml\"";
          example = lib.literalExpression "self + \"/kernels/${kernelName}/pyproject.toml\"";
          description = ''
            Path to `pyproject.toml` of the poetry project that provides this
            ${kernelName} kernel.
          '';
        };

        poetrylock = lib.mkOption {
          type = types.path;
          default = config.projectDir + "/poetry.lock";
          defaultText = lib.literalExpression "kernel.${kernelName}.<name>.projectDir + \"/poetry.lock\"";
          example = lib.literalExpression "self + \"/kernels/${kernelName}/poetry.lock\"";
          description = ''
            Path to `poetry.lock` of the poetry project that provides this
            ${kernelName} kernel.
          '';
        };

        overrides = lib.mkOption {
          type = types.path;
          default = self + "/kernels/available/${kernelName}/overrides.nix";
          defaultText = lib.literalExpression "self + \"/kernels/available/${kernelName}/overrides.nix\"";
          example = lib.literalExpression "self + \"/kernels/${kernelName}/overrides.nix\"";
          description = ''
            Path to `overrides.nix` file which provides python package overrides
            for this ${kernelName} kernel.
          '';
        };

        withDefaultOverrides = lib.mkOption {
          type = types.bool;
          default = true;
          example = lib.literalExpression "false";
          description = ''
            Should we use default overrides provided by `poetry2nix`.
          '';
        };

        python = lib.mkOption {
          type = types.str;
          default = "python3";
          example = "python310";
          description = lib.mdDoc ''
            Name of the python interpreter (from nixpkgs) to be used for this
            ${kernelName} kernel.
          '';
        };

        editablePackageSources = lib.mkOption {
          type = types.attrsOf (types.nullOr types.path);
          default = {};
          example = lib.literalExpression "{}";
          description = ''
            A mapping from package name to source directory, these will be
            installed in editable mode. Note that path dependencies with `develop
            = true` will be installed in editable mode unless explicitly passed
            to `editablePackageSources` as `null`.
          '';
        };

        extraPackages = lib.mkOption {
          type = types.functionTo (types.listOf types.package);
          default = ps: [];
          defaultText = lib.literalExpression "ps: []";
          example = lib.literalExpression "ps: [ps.numpy]";
          description = ''
            A function taking a Python package set and returning a list of extra
            packages to include in the environment. This is intended for
            packages deliberately not added to `pyproject.toml` that you still
            want to include. An example of such a package may be `pip`.
          '';
        };

        preferWheels = lib.mkOption {
          type = types.bool;
          default = false;
          example = lib.literalExpression "true";
          description = lib.mdDoc ''
            Use wheels rather than sdist as much as possible.
          '';
        };

        groups = lib.mkOption {
          type = types.listOf types.str;
          default = ["dev"];
          defaultText = lib.literalExpression "[\"dev\"]";
          example = lib.literalExpression ''["dev" "doc"]'';
          description = lib.mdDoc ''
            Which Poetry 1.2.0+ dependency groups to install for this ${kernelName}
            kernel.
          '';
        };

        poetry2nix = lib.mkOption {
          type = types.path;
          default = self.inputs.poetry2nix;
          defaultText = lib.literalExpression "self.inputs.poetry2nix";
          example = lib.literalExpression "self.inputs.poetry2nix";
          description = lib.mdDoc ''
            poetry2nix flake input to be used for this ${kernelName} kernel.
          '';
        };

        ignoreCollisions = lib.mkOption {
          type = types.bool;
          default = false;
          example = lib.literalExpression "true";
          description = lib.mdDoc ''
            Ignore file collisions inside the environment.
          '';
        };
      }
      // kernelModule.options;

    config = lib.mkIf config.enable {
      kernelArgs =
        rec {
          inherit
            (config)
            projectDir
            pyproject
            poetrylock
            editablePackageSources
            extraPackages
            preferWheels
            groups
            ignoreCollisions
            ;
          pkgs = config.nixpkgs;
          python = pkgs.${config.python};
          poetry = pkgs.callPackage "${config.poetry2nix}/pkgs/poetry" {inherit python;};
          poetry2nix = import "${config.poetry2nix}/default.nix" {inherit pkgs poetry;};
          overrides =
            if config.withDefaultOverrides == true
            then poetry2nix.overrides.withDefaults (import config.overrides)
            else import config.overrides;
        }
        // kernelModule.kernelArgs;
    };
  };
in {
  options.kernel.${kernelName} = lib.mkOption {
    type = types.attrsOf (types.submodule kernelOptions);
    default = {};
    example = lib.literalExpression ''
      {
        kernel.${kernelName}."example".enable = true;
      }
    '';
    description = lib.mdDoc ''
      A ${kernelName} kernel for IPython.
    '';
  };
}
