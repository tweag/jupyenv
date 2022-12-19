{
  name,
  kernelName,
  self,
  system,
  lib,
  config,
}: let
  inherit (lib) types;
in {
  options = {
    projectDir = lib.mkOption {
      type = types.path;
      default = self + "/kernels/available/${kernelName}";
      example = "self + \"/kernels/available/${kernelName}\";";
      description = lib.mdDoc ''
        Path to the root of the poetry project that provides this ${kernelName}
        kernel.
      '';
    };

    pyproject = lib.mkOption {
      type = types.path;
      default = config.projectDir + "/pyproject.toml";
      example = "projectDir + \"/pyproject.toml\"";
      description = lib.mdDoc ''
        Path to `pyproject.toml` of the poetry project that provides this
        ${kernelName} kernel.
      '';
    };

    poetrylock = lib.mkOption {
      type = types.path;
      default = config.projectDir + "/poetry.lock";
      example = "projectDir + \"/poetry.lock\"";
      description = lib.mdDoc ''
        Path to `poetry.lock` of the poetry project that provides this
        ${kernelName} kernel.
      '';
    };

    overrides = lib.mkOption {
      type = types.path;
      default = self + "/kernels/available/${kernelName}/overrides.nix";
      example = "/kernels/available/${kernelName}/overrides.nix";
      description = lib.mdDoc ''
        Path to `overrides.nix` file which provides python package overrides
        for this ${kernelName} kernel.
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
        ${kernelName} kernel.
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
        Which Poetry 1.2.0+ dependency groups to install for this ${kernelName}
        kernel.
      '';
    };

    nixpkgs = lib.mkOption {
      type = types.path;
      default = self.inputs.nixpkgs;
      example = ''
        self.inputs.nixpkgs
      '';
      description = lib.mdDoc ''
        nixpkgs flake input to be used for this ${kernelName} kernel.
      '';
    };

    poetry2nix = lib.mkOption {
      type = types.path;
      default = self.inputs.poetry2nix;
      example = ''
        self.inputs.poetry2nix
      '';
      description = lib.mdDoc ''
        poetry2nix flake input to be used for this ${kernelName} kernel.
      '';
    };
  };

  kernelArgs = rec {
    inherit
      (config)
      projectDir
      pyproject
      poetrylock
      editablePackageSources
      extraPackages
      preferWheels
      groups
      ;
    pkgs = config.nixpkgs.legacyPackages.${system};
    python = pkgs.${config.python};
    poetry = pkgs.callPackage "${config.poetry2nix}/pkgs/poetry" {inherit python;};
    poetry2nix = import "${config.poetry2nix}/default.nix" {inherit pkgs poetry;};
    overrides =
      if config.withDefaultOverrides == true
      then poetry2nix.overrides.withDefaults (import config.overrides)
      else import config.overrides;
  };
}
