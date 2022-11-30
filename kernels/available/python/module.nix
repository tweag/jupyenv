{
  self,
  system,
  config,
  lib,
  ...
}: let
  types = lib.types;

  pythonKernelOptions = {
    config,
    name,
    ...
  }: {
    options = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = lib.mdDoc ''
          Enable python kernel.
        '';
      };

      name = lib.mkOption {
        type = types.str;
        default = "python-${name}";
        example = "science";
        description = lib.mdDoc ''
          Name of the python kernel.
        '';
      };

      displayName = lib.mkOption {
        type = types.str;
        default = "Python ${config.name} kernel";
        example = "Python science kernel";
        description = lib.mdDoc ''
          Display name of the python kernel.
        '';
      };

      runtimePackages = lib.mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          A list of runtime packages available in this python kernel.
        '';
      };

      projectDir = lib.mkOption {
        type = types.path;
        default = self + "/kernels/available/python";
        example = "self + \"/kernels/available/python\";";
        description = lib.mdDoc ''
          Path to the root of the poetry project that provides this python
          kernel.
        '';
      };

      pyproject = lib.mkOption {
        type = types.path;
        default = config.projectDir + "/pyproject.toml";
        example = "projectDir + \"/pyproject.toml\"";
        description = lib.mdDoc ''
          Path to `pyproject.toml` of the poetry project that provides this
          python kernel.
        '';
      };

      poetrylock = lib.mkOption {
        type = types.path;
        default = config.projectDir + "/poetry.lock";
        example = "projectDir + \"/poetry.lock\"";
        description = lib.mdDoc ''
          Path to `poetry.lock` of the poetry project that provides this python
          kernel.
        '';
      };

      overrides = lib.mkOption {
        type = types.path;
        default = ./overrides.nix;
        example = "./overrides.nix";
        description = lib.mdDoc ''
          Path to `overrides.nix` file which provides python package overrides
          for this python kernel.
        '';
      };

      withDefaultOverrides = lib.mkOption {
        type = types.bool;
        default = true;
        example = "false";
        description = lib.mdDoc ''
          Should we use default overrides provided by poetry2nix.
        '';
      };

      python = lib.mkOption {
        type = types.str;
        default = "python3";
        example = "python310";
        description = lib.mdDoc ''
          Name of the python interpreter (from nixpkgs) to be used for this
          python kernel.
        '';
      };

      editablePackageSources = lib.mkOption {
        type = types.attrsOf (types.nullOr types.path);
        default = {};
        example = "{}";
        description = lib.mdDoc ''
          A mapping from package name to source directory, these will be
          installed in editable mode. Note that path dependencies with `develop
          = true` will be installed in editable mode unless explicitly passed
          to `editablePackageSources` as `null`.
        '';
      };

      extraPackages = lib.mkOption {
        type = types.functionTo (types.listOf types.package);
        default = ps: [];
        example = "ps: []";
        description = lib.mdDoc ''
          A function taking a Python package set and returning a list of extra
          packages to include in the environment. This is intended for
          packages deliberately not added to `pyproject.toml` that you still
          want to include. An example of such a package may be `pip`.
        '';
      };

      preferWheels = lib.mkOption {
        type = types.bool;
        default = false;
        example = "true";
        description = lib.mdDoc ''
          Use wheels rather than sdist as much as possible.
        '';
      };

      groups = lib.mkOption {
        type = types.listOf types.str;
        default = ["dev"];
        example = ''["dev" "doc"]'';
        description = lib.mdDoc ''
          Which Poetry 1.2.0+ dependency groups to install for this python
          kernel.
        '';
      };

      nixpkgs = lib.mkOption {
        type = types.package;
        default = self.inputs.nixpkgs;
        example = ''
          self.inputs.nixpkgs
        '';
        description = lib.mdDoc ''
          nixpkgs flake input to be used for this python kernel.
        '';
      };

      poetry2nix = lib.mkOption {
        type = types.package;
        default = self.inputs.poetry2nix;
        example = ''
          self.inputs.poetry2nix
        '';
        description = lib.mdDoc ''
          poetry2nix flake input to be used for this python kernel.
        '';
      };
    };
  };
in {
  options.kernel.python = lib.mkOption {
    type = types.attrsOf (types.submodule pythonKernelOptions);
    default = {};
    example = ''
      {
        kernel.python."science".enable = true;
      }
    '';
    description = lib.mdDoc ''
      IPython Kernel for Jupyter.
    '';
  };
}
